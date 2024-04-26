//
//  mocks.swift
//  CHEPICS
//
//  Created by Tatsuyoshi Kawajiri on 2024/03/20.
//

import Foundation

let mockTopic1 = Topic(id: "1", title: "猫が可愛い", link: "https://www.google.com/", description: "猫がいっぱいいるよ", images: [mockTopicImage1, mockTopicImage2, mockTopicImage3, mockTopicImage4], user: mockUser1, votes: 10000, set: nil, registerTime: getPreviousDate(value: 1), updateTime: Date())
let mockTopic2 = Topic(id: "2", title: "終わらぬ冒険: 時空を越えた旅", link: "https://www.google.com/", description: "猫がいっぱいいるよ", images: [mockTopicImage1, mockTopicImage3, mockTopicImage4], user: mockUser2, votes: 1000, set: nil, registerTime: getPreviousDate(value: 2), updateTime: Date())
let mockTopic3 = Topic(id: "3", title: "暁の秘密: 深淵に眠る謎の輝き", link: "https://www.google.com/", description: "猫がいっぱいいるよ", images: [mockTopicImage2, mockTopicImage3, mockTopicImage4], user: mockUser3, votes: 654, set: nil, registerTime: getPreviousDate(value: 3), updateTime: Date())
let mockTopic4 = Topic(id: "4", title: "疾走する影: 運命の追跡者", link: "https://www.google.com/", description: "猫がいっぱいいるよ", images: [mockTopicImage1], user: mockUser4, votes: 6533, set: nil, registerTime: getPreviousDate(value: 4), updateTime: Date())
let mockTopic5 = Topic(id: "5", title: "天空の守護者: 魔法の羽根が舞う", link: "https://www.google.com/", description: "猫がいっぱいいるよ", images: [mockTopicImage3, mockTopicImage4], user: mockUser5, votes: 654, set: nil, registerTime: getPreviousDate(value: 5), updateTime: Date())
let mockTopic6 = Topic(id: "6", title: "希望の光: 闇を切り裂く勇者の物語", link: "https://www.google.com/", description: "猫がいっぱいいるよ", images: nil, user: mockUser6, votes: 123, set: nil, registerTime: getPreviousDate(value: 6), updateTime: Date())
let mockTopic7 = Topic(id: "7", title: "運命の輪: 世界を繋ぐ紡がれし絆", link: "https://www.google.com/", description: "猫がいっぱいいるよ", images: [mockTopicImage1, mockTopicImage2, mockTopicImage4], user: mockUser7, votes: 9876, set: nil, registerTime: getPreviousDate(value: 7), updateTime: Date())
let mockTopic8 = Topic(id: "8", title: "永遠の幻想: 神秘の楽園への扉", link: "https://www.google.com/", description: "猫がいっぱいいるよ", images: [mockTopicImage1, mockTopicImage2, mockTopicImage3, mockTopicImage4], user: mockUser8, votes: 34, set: nil, registerTime: getPreviousDate(value: 8), updateTime: Date())
let mockTopic9 = Topic(id: "9", title: "蒼き旋律: 心を揺さぶる音色の響き", link: "https://www.google.com/", description: "猫がいっぱいいるよ", images: nil, user: mockUser9, votes: 654, set: nil, registerTime: getPreviousDate(value:9), updateTime: Date())
let mockTopic10 = Topic(id: "10", title: "炎の舞踏: 火花散る情熱の輝き", link: "https://www.google.com/", description: "猫がいっぱいいるよ", images: [mockTopicImage2, mockTopicImage4], user: mockUser10, votes: 343, set: nil, registerTime: getPreviousDate(value: 10), updateTime: Date())
let mockTopic11 = Topic(id: "11", title: "未知の彼方: 新たなる世界への冒険", link: "https://www.google.com/", description: "猫がいっぱいいるよ", images: [mockTopicImage1, mockTopicImage2, mockTopicImage3], user: mockUser11, votes: 654, set: nil, registerTime: getPreviousDate(value: 11), updateTime: Date())
let mockTopic12 = Topic(id: "12", title: "魔法の森の物語: 妖精たちの守り人", link: "https://www.google.com/", description: "猫がいっぱいいるよ", images: [mockTopicImage2, mockTopicImage3], user: mockUser12, votes: 324, set: nil, registerTime: getPreviousDate(value: 12), updateTime: Date())
let mockTopic13 = Topic(id: "13", title: "幽玄の旅路: 時間と空間を超えた神秘の旅", link: "https://www.google.com/", description: "猫がいっぱいいるよ", images: [mockTopicImage2, mockTopicImage3, mockTopicImage4], user: mockUser13, votes: 543, set: nil, registerTime: getPreviousDate(value: 13), updateTime: Date())
let mockTopic14 = Topic(id: "14", title: "氷の領域: 凍てつく永遠の美しき氷の世界", link: "https://www.google.com/", description: "猫がいっぱいいるよ", images: [mockTopicImage1], user: mockUser14, votes: 23, set: nil, registerTime: getPreviousDate(value: 14), updateTime: Date())
let mockTopic15 = Topic(id: "15", title: "夢見る星: 希望を導く星の輝き", link: "https://www.google.com/", description: "猫がいっぱいいるよ", images: [mockTopicImage1, mockTopicImage2, mockTopicImage4], user: mockUser15, votes: 987, set: nil, registerTime: getPreviousDate(value: 15), updateTime: Date())

let mockTopicImage1 = TopicImage(id: "1", topicId: "1", url: "https://doremifahiroba.com/wp-content/uploads/2022/11/EP01_30-1024x576.jpg")
let mockTopicImage2 = TopicImage(id: "2", topicId: "1", url: "https://realsound.jp/wp-content/uploads/2023/01/20230121-gudetama-07.jpg")
let mockTopicImage3 = TopicImage(id: "3", topicId: "1", url: "https://eiga.k-img.com/images/anime/news/117485/photo/46fcf777bd7b0902/640.jpg?1669974887")
let mockTopicImage4 = TopicImage(id: "4", topicId: "1", url: "https://netofuli.com/wp-content/uploads/2022/12/%E3%82%B9%E3%82%AF%E3%83%AA%E3%83%BC%E3%83%B3%E3%82%B7%E3%83%A7%E3%83%83%E3%83%88-2022-12-17-18.40.30.jpg")

let mockComment1 = Comment(id: "1", parentId: "1", topicId: "1", setId: "1", comment: "夢見る星: 希望を導く星の輝き", link: "https://www.google.com/", images: [mockCommentImage1, mockCommentImage2, mockCommentImage3, mockCommentImage4], votes: 4353, user: mockUser15, registerTime: getPreviousDate(value: 1), updateTime: Date())
let mockComment2 = Comment(id: "2", parentId: "1", topicId: "1", setId: "1", comment: "氷の領域: 凍てつく永遠の美しき氷の世界", link: "https://www.google.com/", images: [mockCommentImage1, mockCommentImage2, mockCommentImage4], votes: 9876, user: mockUser14, registerTime: getPreviousDate(value: 1), updateTime: Date())
let mockComment3 = Comment(id: "3", parentId: "1", topicId: "1", setId: "1", comment: "幽玄の旅路: 時間と空間を超えた神秘の旅", link: "https://www.google.com/", images: [mockCommentImage3], votes: 1234, user: mockUser13, registerTime: getPreviousDate(value: 1), updateTime: Date())
let mockComment4 = Comment(id: "4", parentId: "1", topicId: "1", setId: "1", comment: "魔法の森の物語: 妖精たちの守り人", link: "https://www.google.com/", images: [mockCommentImage3, mockCommentImage4, mockCommentImage2], votes: 4353, user: mockUser12, registerTime: getPreviousDate(value: 1), updateTime: Date())

let mockCommentImage1 = CommentImage(id: "1", commentId: "1", url: "https://doremifahiroba.com/wp-content/uploads/2022/11/EP01_30-1024x576.jpg")
let mockCommentImage2 = CommentImage(id: "2", commentId: "1", url: "https://realsound.jp/wp-content/uploads/2023/01/20230121-gudetama-07.jpg")
let mockCommentImage3 = CommentImage(id: "3", commentId: "1", url: "https://eiga.k-img.com/images/anime/news/117485/photo/46fcf777bd7b0902/640.jpg?1669974887")
let mockCommentImage4 = CommentImage(id: "4", commentId: "1", url: "https://netofuli.com/wp-content/uploads/2022/12/%E3%82%B9%E3%82%AF%E3%83%AA%E3%83%BC%E3%83%B3%E3%82%B7%E3%83%A7%E3%83%83%E3%83%88-2022-12-17-18.40.30.jpg")

let mockUser1 = User(
    id: "1",
    email: "chepics.com",
    username: "taro",
    fullname: "太郎",
    bio: "技術の世界では、エンジニアや開発者は常に新しいアルゴリズムやプログラミング言語を探求し、さまざまな課題に対処するための革新的なソリューションを提供しようと努力しています。例えば、人工知能や機械学習の分野では、データの解析や予測モデルの構築に関する研究が進んでおり、これによってビジネスや科学の分野で革新的な進展が可能になっています。",
    profileImageUrl: "https://animeanime.jp/imgs/ogp_f/303592.jpg",
    registerTime: Date(),
    updateTime: Date()
)
let mockUser2 = User(
    id: "2",
    email: "chepics.com",
    username: "Sakura",
    fullname: "さくら",
    bio: nil,
    profileImageUrl: "https://d1uzk9o9cg136f.cloudfront.net/f/16783489/rc/2022/10/25/b86bd6fa3f0fc8c9cb3aaa5eb26bfd60066a598e.jpg",
    registerTime: Date(),
    updateTime: Date()
)
let mockUser3 = User(
    id: "3",
    email: "chepics.com",
    username: "Yuta",
    fullname: "ゆうた",
    bio: nil,
    profileImageUrl: "https://static.gltjp.com/glt/prd/data/article/21000/20584/20240112_113107_c7298818_w1920.jpg",
    registerTime: Date(),
    updateTime: Date()
)
let mockUser4 = User(
    id: "4",
    email: "chepics.com",
    username: "Akari",
    fullname: "あかり",
    bio: nil,
    profileImageUrl: "https://img.freepik.com/free-photo/fuji-mountain-and-kawaguchiko-lake-in-morning-autumn-seasons-fuji-mountain-at-yamanachi-in-japan_335224-102.jpg?size=626&ext=jpg&ga=GA1.1.967060102.1710806400&semt=ais",
    registerTime: Date(),
    updateTime: Date()
)
let mockUser5 = User(
    id: "5",
    email: "chepics.com",
    username: "Haruto",
    fullname: "はると",
    bio: nil,
    profileImageUrl: "https://fujifilmsquare.jp/assets/img/column/column_39_01.jpg",
    registerTime: Date(),
    updateTime: Date()
)
let mockUser6 = User(
    id: "6",
    email: "chepics.com",
    username: "Mizuki",
    fullname: "みずき",
    bio: nil,
    profileImageUrl: "https://tabiiro.jp/auto_sysnc/images/article/2738/share_images1671604951.jpg",
    registerTime: Date(),
    updateTime: Date()
)
let mockUser7 = User(
    id: "7",
    email: "chepics.com",
    username: "Rio",
    fullname: "りお",
    bio: nil,
    profileImageUrl: "https://img01.jalannews.jp/img/2023/06/202307_kanto_1_114-670x443.jpg",
    registerTime: Date(),
    updateTime: Date()
)
let mockUser8 = User(
    id: "8",
    email: "chepics.com",
    username: "Riku",
    fullname: "りく",
    bio: nil,
    profileImageUrl: "https://discoverjapan-web.com/wp-content/uploads/2020/06/4ffe6b26cd5640fa352a979cc7a96dd7.jpg",
    registerTime: Date(),
    updateTime: Date()
)
let mockUser9 = User(
    id: "9",
    email: "chepics.com",
    username: "Airi",
    fullname: "あいり",
    bio: nil,
    profileImageUrl: "https://prtimes.jp/i/7916/471/resize/d7916-471-835089-22.jpg",
    registerTime: Date(),
    updateTime: Date()
)
let mockUser10 = User(
    id: "10",
    email: "chepics.com",
    username: "Shunsuke",
    fullname: "しゅんすけ",
    bio: nil,
    profileImageUrl: "https://travel.rakuten.co.jp/mytrip/sites/mytrip/files/styles/main_image/public/migration_article_images/amazing/amazingviews-kanto-key.jpg?itok=F7xs4yDv",
    registerTime: Date(),
    updateTime: Date()
)
let mockUser11 = User(
    id: "11",
    email: "chepics.com",
    username: "Rena",
    fullname: "れな",
    bio: nil,
    profileImageUrl: "https://fs.tour.ne.jp/index.php/file_manage/view/?contents_code=curation&file_name=814/27186/98ca4c60e2fcc431d31fdc8fd05c7bc3.jpg&w=1200",
    registerTime: Date(),
    updateTime: Date()
)
let mockUser12 = User(
    id: "12",
    email: "chepics.com",
    username: "Kaito",
    fullname: "かいと",
    bio: nil,
    profileImageUrl: "https://media.vogue.co.jp/photos/64df24ddd343815066c32ece/master/w_1600%2Cc_limit/VJ-travel-world-bridge-06.jpeg",
    registerTime: Date(),
    updateTime: Date()
)
let mockUser13 = User(
    id: "13",
    email: "chepics.com",
    username: "Mana",
    fullname: "まな",
    bio: nil,
    profileImageUrl: "https://cdn.fujiyama-navi.jp/entries/images/000/004/668/original/6688648b-443d-4f6b-a39f-be2240ea06e3.jpg?1516586033",
    registerTime: Date(),
    updateTime: Date()
)
let mockUser14 = User(
    id: "14",
    email: "chepics.com",
    username: "Taichi",
    fullname: "たいち",
    bio: nil,
    profileImageUrl: "https://animeanime.jp/imgs/ogp_f/303592.jpg",
    registerTime: Date(),
    updateTime: Date()
)
let mockUser15 = User(
    id: "15",
    email: "chepics.com",
    username: "Rin",
    fullname: "りん",
    bio: nil,
    profileImageUrl: "https://www.nta.co.jp/media/tripa/static_contents/nta-tripa/item_images/images/000/066/242/medium/8c11da1d-97de-4c99-96dd-78089cc52f72.jpg?1550676731",
    registerTime: Date(),
    updateTime: Date()
)

func getPreviousDate(value: Int) -> Date {
    let currentDate = Date()
    let calendar = Calendar.current
    return calendar.date(byAdding: .day, value: -value, to: currentDate) ?? Date()
}
