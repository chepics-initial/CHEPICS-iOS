//
//  CustomTextView.swift
//  CHEPICS
//
//  Created by tatsuyoshi-kawajiri on 2024/05/17.
//

import SwiftUI

struct CustomTextView: UIViewRepresentable {
    @Binding var text: String
    @Binding var height: CGFloat
    
    private let textView = UITextView()
    
    init(text: Binding<String>, height: Binding<CGFloat>) {
        _text = text
        _height = height
    }
    
    func makeUIView(context: UIViewRepresentableContext<CustomTextView>) -> UITextView {
        textView.backgroundColor = .clear
        textView.delegate = context.coordinator
        textView.font = .systemFont(ofSize: 16)
        textView.text = _text.wrappedValue
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: UIViewRepresentableContext<CustomTextView>) {
        if uiView.text != _text.wrappedValue {
            uiView.text = _text.wrappedValue
        }
    }
    
    func makeCoordinator() -> CustomTextView.Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        var parent: CustomTextView
        
        init(_ parent: CustomTextView) {
            self.parent = parent
            super.init()
        }
        
        func textViewDidChange(_ textView: UITextView) {
            parent.text = textView.text
            let textViewSize = textView.sizeThatFits(textView.bounds.size)
            parent.height = textViewSize.height
        }
    }
}
