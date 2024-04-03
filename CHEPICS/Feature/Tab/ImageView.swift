//
//  ImageView.swift
//  CHEPICS
//
//  Created by tatsuyoshi-kawajiri on 2024/03/21.
//

import SwiftUI
import Kingfisher
import NukeUI

struct ImageView: View {
    @EnvironmentObject var viewModel: MainTabViewModel
    let onDismiss: () -> Void
    
    var body: some View {
        GeometryReader { geometry in
            let pageSize = geometry.size
            HStack(spacing: 0) {
                ForEach(viewModel.images, id: \.self) { imageUrl in
                    ImagePagerPage(
                        pagerState: $viewModel.pagerState,
                        imageUrl: URL(string: imageUrl),
                        pageSize: pageSize,
                        onDismiss: onDismiss
                    ).frame(width: pageSize.width, height: pageSize.height)
                }
            }
            .frame(width: pageSize.width * CGFloat(viewModel.pagerState.pageCount), height: pageSize.height)
            // ✅ オフセットを変えることで擬似的に HorizontalPager の振る舞いを再現する
            .offset(viewModel.pagerState.offset)
            .background(Color.black)
        }
    }
}

private struct ImagePagerPage: View {
    @Binding var pagerState: ImagePagerState
    let imageUrl: URL?
    let pageSize: CGSize
    let onDismiss: () -> Void
    
    var body: some View {
        // 📝 B/43では画像の表示に Nuke (LazyImage)　を使用している
        // https://github.com/kean/Nuke
        LazyImage(url: imageUrl) { state in
            if case .success(let response) = state.result {
                let imageSize = response.image.size
                let widthFitSize = CGSize(
                    width: pageSize.width,
                    height: imageSize.height * (pageSize.width / imageSize.width)
                )
                let heightFitSize = CGSize(
                    width: imageSize.width * (pageSize.height / imageSize.height),
                    height: pageSize.height
                )
                let fitImageSize = widthFitSize.height > pageSize.height ? heightFitSize : widthFitSize
                Image(uiImage: response.image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: pageSize.width, height: pageSize.height)
                    .modifier(
                        ImageGestureModifier(
                            pageSize: pageSize,
                            imageSize: fitImageSize,
                            onDraggingOver: {
                                pagerState.moveToDesiredOffset(pageSize: pageSize, additionalOffset: $0)
                            },
                            onDraggingOverEnded: { predictedEndTranslation in
                                // ✅ 水平方向のドラッグ操作が完了した後、 `predictedEndTranslation` （慣性を考慮した移動量）を基に前後のページへ移動する
                                let scrollThreshold = pageSize.width / 2.0
                                withAnimation(.easeOut) {
                                    if predictedEndTranslation.width < -scrollThreshold {
                                        pagerState.scrollToNextPage(pageSize: pageSize)
                                    } else if predictedEndTranslation.width > scrollThreshold {
                                        pagerState.scrollToPrevPage(pageSize: pageSize)
                                    } else {
                                        pagerState.moveToDesiredOffset(pageSize: pageSize)
                                    }
                                }
                                
                                // 垂直方向のドラッグ操作が完了した後、 `predictedEndTranslation` を基に必要に応じて画面を閉じる
                                let dismisssThreshold = pageSize.height / 4.0
                                if abs(predictedEndTranslation.height) > dismisssThreshold {
                                    withAnimation(.easeOut) {
                                        pagerState.invokeDismissTransition(
                                            pageSize: pageSize,
                                            predictedEndTranslationY: predictedEndTranslation.height
                                        )
                                    }
                                    onDismiss()
                                }
                            },
                            onDraggingOverCanceled: {
                                pagerState.moveToDesiredOffset(pageSize: pageSize)
                            }
                        )
                    )
            }
        }
    }
}

struct ImagePagerState {
    private(set) var pageCount: Int
    private(set) var currentIndex: Int
    private(set) var offset: CGSize = .zero
    
    private var prevIndex: Int {
        max(currentIndex - 1, 0)
    }
    private var nextIndex: Int {
        min(currentIndex + 1, pageCount - 1)
    }
    
    init(pageCount: Int, initialIndex: Int = 0, pageSize: CGSize) {
        self.pageCount = pageCount
        self.currentIndex = initialIndex
        offset = CGSize(
            width: -pageSize.width * CGFloat(currentIndex) + offset.width,
            height: offset.height
        )
    }
    
    mutating func scrollToPrevPage(pageSize: CGSize) {
        currentIndex = prevIndex
        moveToDesiredOffset(pageSize: pageSize)
    }
    
    mutating func scrollToNextPage(pageSize: CGSize) {
        currentIndex = nextIndex
        moveToDesiredOffset(pageSize: pageSize)
    }
    
    mutating func invokeDismissTransition(pageSize: CGSize, predictedEndTranslationY: CGFloat) {
        moveToDesiredOffset(
            pageSize: pageSize,
            additionalOffset: CGSize(width: 0, height: predictedEndTranslationY)
        )
    }
    
    mutating func moveToDesiredOffset(pageSize: CGSize, additionalOffset: CGSize = .zero) {
        offset = CGSize(
            width: -pageSize.width * CGFloat(currentIndex) + additionalOffset.width,
            height: additionalOffset.height
        )
    }
}

private struct ImageGestureModifier: ViewModifier {
    let pageSize: CGSize
    let imageSize: CGSize
    
    // ✅ 画像端を超えてドラッグした際の移動量をコールバックで受け取れるようにしている
    let onDraggingOver: (CGSize) -> Void
    let onDraggingOverEnded: (CGSize) -> Void
    let onDraggingOverCanceled: () -> Void
    
    @State private var currentScale: CGFloat = 1.0
    @State private var previousScale: CGFloat = 1.0
    
    @State private var currentOffset = CGSize.zero
    @State private var unclampedOffset = CGSize.zero
    @State private var previousTranslation = CGSize.zero
    
    @State private var draggingOverAxis: DraggingOverAxis?
    
    // ドラッグ操作用の Gesture
    var dragGesture: some Gesture {
        DragGesture(coordinateSpace: .global)
            .onChanged { value in
                handleDragGestureValueChanged(value)
            }
            .onEnded { value in
                handleDragGestureValueChanged(value)
                
                previousTranslation = .zero
                unclampedOffset = currentOffset
                
                let (draggableRangeX, draggableRangeY) = calculateDraggableRange()
                if draggingOverAxis == .horizontal {
                    if currentOffset.width <= draggableRangeX.lowerBound || draggableRangeX.upperBound <= currentOffset.width {
                        onDraggingOverEnded(CGSize(width: value.predictedEndTranslation.width, height: 0))
                    } else {
                        onDraggingOverCanceled()
                    }
                } else if draggingOverAxis == .vertical {
                    if currentOffset.height <= draggableRangeY.lowerBound || draggableRangeY.upperBound <= currentOffset.height {
                        onDraggingOverEnded(CGSize(width: 0, height: value.predictedEndTranslation.height))
                    } else {
                        onDraggingOverCanceled()
                    }
                }
                
                draggingOverAxis = nil
            }
    }
    // ピンチインでの拡大・縮小操作用の Gesture
    var pinchGesture: some Gesture {
        if #available(iOS 17.0, *) {
            return MagnifyGesture()
                .onChanged { value in
                    let delta = value.magnification / previousScale
                    previousScale = value.magnification
                    currentScale = clamp(min: 0.8, val: currentScale * delta, max: 3.0)
                }
                .onEnded { value in
                    let delta = value.magnification / previousScale
                    previousScale = 1.0
                    withAnimation {
                        currentScale = clamp(min: 1.0, val: currentScale * delta, max: 2.5)
                        currentOffset = clampInDraggableRange(offset: currentOffset)
                    }
                }
        } else {
            return MagnificationGesture()
                .onChanged { value in
                    let delta = value / previousScale
                    previousScale = value
                    currentScale = clamp(min: 1.0, val: currentScale * delta, max: 2.5)
                }
                .onEnded { value in
                    let delta = value / previousScale
                    previousScale = 1.0
                    withAnimation {
                        currentScale = clamp(min: 1.0, val: currentScale * delta, max: 2.5)
                        currentOffset = clampInDraggableRange(offset: currentOffset)
                    }
                }
        }
    }
    
    func body(content: Content) -> some View {
        content.offset(x: currentOffset.width, y: currentOffset.height)
            .scaleEffect(currentScale)
            .clipShape(Rectangle())
            .gesture(dragGesture)
            .simultaneousGesture(pinchGesture)
    }
    
    /// ドラッグ操作の移動量から画像の表示位置（オフセット）を確定させる
    ///
    /// 画像端を超えてドラッグしていた場合は移動量を `onDraggingOver` のコールバックに通知する。
    private func handleDragGestureValueChanged(_ value: DragGesture.Value) {
        let delta = CGSize(
            width: value.translation.width - previousTranslation.width,
            height: value.translation.height - previousTranslation.height
        )
        previousTranslation = CGSize(
            width: value.translation.width,
            height: value.translation.height
        )
        unclampedOffset = CGSize(
            width: unclampedOffset.width + delta.width / currentScale,
            height: unclampedOffset.height + delta.height / currentScale
        )
        currentOffset = clampInDraggableRange(offset: unclampedOffset)
        
        // ✅ 画像端を考慮したオフセット（ `currentOffset` ）と考慮しないオフセット（ `unclampedOffset` ）に差がある場合にコールバックを呼び出す
        // 画像端を超えてドラッグを開始した後はもう一方向の移動量を無視し、前後の画像への切り替えと画面を閉じる操作を同時に機能させない
        switch draggingOverAxis {
        case .horizontal:
            if unclampedOffset.width != currentOffset.width {
                onDraggingOver(CGSize(width: unclampedOffset.width - currentOffset.width, height: 0))
            } else {
                draggingOverAxis = nil
                onDraggingOverCanceled()
            }
        case .vertical:
            if unclampedOffset.height != currentOffset.height {
                onDraggingOver(CGSize(width: 0, height: unclampedOffset.height - currentOffset.height))
            } else {
                draggingOverAxis = nil
                onDraggingOverCanceled()
            }
        case nil:
            if unclampedOffset != currentOffset {
                if abs(unclampedOffset.width - currentOffset.width) > abs(unclampedOffset.height - currentOffset.height) {
                    draggingOverAxis = .horizontal
                    onDraggingOver(CGSize(width: unclampedOffset.width - currentOffset.width, height: 0))
                } else {
                    draggingOverAxis = .vertical
                    onDraggingOver(CGSize(width: 0, height: unclampedOffset.height - currentOffset.height))
                }
            }
        }
    }
    
    private func calculateDraggableRange() -> (ClosedRange<CGFloat>, ClosedRange<CGFloat>) {
        let scaledImageSize = CGSize(
            width: imageSize.width * currentScale,
            height: imageSize.height * currentScale
        )
        let draggableSize = CGSize(
            width: max(0, scaledImageSize.width - pageSize.width),
            height: max(0, scaledImageSize.height - pageSize.height)
        )
        return (
            -(draggableSize.width / 2 / currentScale)...(draggableSize.width / 2 / currentScale),
             -(draggableSize.height / 2 / currentScale)...(draggableSize.height / 2 / currentScale)
        )
    }
    
    private func clampInDraggableRange(offset: CGSize) -> CGSize {
        let (draggableHorizontalRange, draggableVerticalRange) = calculateDraggableRange()
        return CGSize(
            width: clamp(
                min: draggableHorizontalRange.lowerBound,
                val: offset.width,
                max: draggableHorizontalRange.upperBound
            ),
            height: clamp(
                min: draggableVerticalRange.lowerBound,
                val: offset.height,
                max: draggableVerticalRange.upperBound
            )
        )
    }
    
    private enum DraggingOverAxis: Equatable {
        case horizontal
        case vertical
    }
}

func clamp(min: CGFloat, val: CGFloat, max: CGFloat) -> CGFloat {
    if min > val {
        return min
    }
    
    if max > val {
        return val
    }
    
    return max
}

#Preview {
    ImageView(onDismiss: {})
}
