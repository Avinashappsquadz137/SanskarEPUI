//
//  BookKathaView.swift
//  SanskarEPUI
//
//  Created by Sanskar IOS Dev on 30/05/25.
//
import SwiftUI

enum ActiveSheetType {
    case category
    case time
}

extension ActiveSheetType: Identifiable {
    var id: Int {
        switch self {
        case .category: return 0
        case .time: return 1
        }
    }
}
struct BookKathaView: View {
    
    @State private var activeSheet: ActiveSheetType? = nil
    @State private var selectedChannel: String? = nil
    @State private var selectedCategory: String? = nil

    @State private var channels: [ChannelList] = []
    @State private var kathaTime: [KathaTimingCategory] = []
    @State private var existGuru: [ExistGuruList] = []

    @State private var categoryList: [KathaCategory] = []

    @State private var selectedUIImage: UIImage?
    @State private var selectedFileUrl: URL?
    
    @State private var suggestedFromDate = Date()
    @State private var suggestedToDate = Date()
    
    @State private var selectedSlot: KathaTimingCategory?
    @State private var guruSearchText: String = ""
    @State private var showGuruList = false
    
    @State private var venue = ""
    @State private var amount = ""
    
    func filteredGuruList() -> [ExistGuruList] {
        if guruSearchText.isEmpty {
            return existGuru
        } else {
            return existGuru.filter { guru in
                guru.guru_name?.localizedCaseInsensitiveContains(guruSearchText) ?? false
            }
        }
    }


    var body: some View {
        VStack(alignment: .leading){
            ScrollView {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 5) {
                        ForEach(channels, id: \.sno) { channel in
                            HStack(spacing: 1) {
                                Button(action: {
                                    selectedChannel = (selectedChannel == channel.channelName) ? nil : channel.channelName
                                }) {
                                    Image(systemName: selectedChannel == channel.channelName ? "checkmark.circle.fill" : "circle")
                                        .foregroundColor(selectedChannel == channel.channelName ? .green : .gray)
                                        .imageScale(.medium)
                                }
                                let imageUrlString = "\(Constant.imageURL)\(channel.channel_thumbnail ?? "")"
                                AsyncImage(url: URL(string: "\(imageUrlString)")) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                } placeholder: {
                                    Color.gray.opacity(0.2)
                                }
                                .frame(width: 80, height: 50)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .shadow(radius: 2)
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.top)
                }
                
                // MARK: - Dropdown (Picker) for Katha Category
                Button(action: {
                    activeSheet = .category
                }) {
                    HStack {
                        Text(selectedCategory ?? "Select Katha Category")
                            .foregroundColor(selectedCategory == nil ? .gray : .primary)
                        Spacer()
                        Image(systemName: "chevron.down")
                            .foregroundColor(.gray)
                        
                    }
                    .padding(10)
                    .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray))
                    .padding(.horizontal)
                }
                FilePickerAdsView(
                    selectedCategory: $selectedCategory,
                    selectedUIImage: $selectedUIImage,
                    selectedFileUrl: $selectedFileUrl
                )
                VStack(alignment: .leading){
                    Text("Select Date & Time").fontWeight(.bold)
                    
                    HStack(alignment: .center){
                        DatePicker(
                            "From",
                            selection: $suggestedFromDate,
                            displayedComponents: [.date]
                        )
                        .labelsHidden()
                        .datePickerStyle(.compact)
                        
                        DatePicker(
                            "To ",
                            selection: $suggestedToDate,
                            in: suggestedFromDate...,
                            displayedComponents: [.date]
                        )
                        .labelsHidden()
                        .datePickerStyle(.compact)
                    }
                }
                .padding()
                Button(action: {
                    activeSheet = .time
                }) {
                    HStack {
                        Text(selectedSlot == nil ? "Select Time" : "\(selectedSlot?.slotName ?? "") \(selectedSlot?.slotTiming ?? "")")
                            .foregroundColor(selectedSlot == nil ? .gray : .primary)
                        Spacer()
                        Image(systemName: "chevron.down")
                            .foregroundColor(.gray)
                    }
                    .padding(10)
                    .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray))
                    .padding(.horizontal)
                }
                
                if selectedSlot?.slotName == "Custom" {
                    HStack(alignment: .center){
                        DatePicker(
                            "From",
                            selection: $suggestedFromDate,
                            displayedComponents: [.hourAndMinute]
                        )
                        .labelsHidden()
                        .datePickerStyle(.compact)
                        
                        DatePicker(
                            "To ",
                            selection: $suggestedToDate,
                            in: suggestedFromDate...,
                            displayedComponents: [.hourAndMinute]
                        )
                        .labelsHidden()
                        .datePickerStyle(.compact)
                    }
                    .padding(.horizontal)
                    
                }
                VStack(alignment: .leading) {
                    Text("Select Guru")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    TextField("Search Guru...", text: $guruSearchText, onEditingChanged: { editing in
                        showGuruList = editing
                    })
                    .padding(10)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                    .padding(.horizontal)
                    ZStack{
                    if showGuruList && !filteredGuruList().isEmpty {
                        ScrollView {
                            LazyVStack(alignment: .leading, spacing: 10) {
                                ForEach(filteredGuruList(), id: \.guru_ID) { guru in
                                    Text(guru.guru_name ?? "Unknown")
                                        .padding(.horizontal)
                                        .padding(.vertical, 5)
                                        .background(Color.blue.opacity(0.1))
                                        .cornerRadius(8)
                                        .padding(.horizontal)
                                        .onTapGesture {
                                            guruSearchText = guru.guru_name ?? ""
                                            showGuruList = false
                                        }
                                }
                            }
                        }
                    }
                 }
                }
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 16) {
                        TextField("Enter Venue", text: $venue)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray))

                        TextField("Enter Amount", text: $amount)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray))
                    }
                }
                .padding(.horizontal)
            }
            
            Spacer()
        }
        .navigationTitle("Book Katha")
        .actionSheet(item: $activeSheet) { sheet in
            switch sheet {
            case .category:
                return ActionSheet(
                    title: Text("Select Katha Category"),
                    buttons: categoryList.map { category in
                        .default(Text(category.kathaName ?? "Unknown")) {
                            selectedCategory = category.kathaName
                            getKathaTimingCategoryAPI(kathaIds: String(category.iD ?? 0))
                        }
                    } + [.cancel()]
                )
            case .time:
                return ActionSheet(
                    title: Text("Select Katha Time"),
                    buttons: kathaTime.map { slot in
                            .default(Text("\(slot.slotTiming ?? "") - \(slot.slotName ?? "") ")) {
                            selectedSlot = slot
                        }
                    } + [.cancel()]
                )
            }
        }
        .onAppear {
            channelListApi()
            kathaCategoryApi()
            existGuruListAPI()
        }
    }

    func existGuruListAPI(){
        var dict = Dictionary<String, Any>()
        dict["EmpCode"] = UserDefaultsManager.getEmpCode()
        dict["searchTerm"] = ""
        
        ApiClient.shared.callmethodMultipart(
            apiendpoint: Constant.existGuruList,
            method: .post,
            param: dict,
            model: ExistGuruListModel.self
        ) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    self.existGuru = model.data ?? []
                    print(model.data ?? [])
                    ToastManager.shared.show(message: model.message ?? "Success")
                case .failure(let error):
                    ToastManager.shared.show(message: "Error: \(error.localizedDescription)")
                    print("API Error: \(error)")
                }
            }
        }
    }

    func getKathaTimingCategoryAPI(kathaIds : String){
        var dict = Dictionary<String, Any>()
        dict["category_id"] = kathaIds
        ApiClient.shared.callmethodMultipart(
            apiendpoint: Constant.getKathaTimingCategory,
            method: .post,
            param: dict,
            model: KathaTimingCategoryModel.self
        ) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    self.kathaTime = model.data ?? []
                    print(model.data ?? [])
                    ToastManager.shared.show(message: model.message ?? "Success")
                case .failure(let error):
                    ToastManager.shared.show(message: "Error: \(error.localizedDescription)")
                    print("API Error: \(error)")
                }
            }
        }
    }
    
    func channelListApi() {
        ApiClient.shared.callmethodMultipart(
            apiendpoint: Constant.channelList,
            method: .post,
            param: [:],
            model: ChannelListModel.self
        ) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    self.channels = model.data ?? []
                    ToastManager.shared.show(message: model.message ?? "Success")
                case .failure(let error):
                    ToastManager.shared.show(message: "Error: \(error.localizedDescription)")
                    print("API Error: \(error)")
                }
            }
        }
    }
    func kathaCategoryApi() {
        ApiClient.shared.callmethodMultipart(
            apiendpoint: Constant.kathaCategory,
            method: .post,
            param: [:],
            model: KathaCategoryModel.self
        ) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    self.categoryList = model.data ?? []
                    ToastManager.shared.show(message: model.message ?? "Success")
                case .failure(let error):
                    ToastManager.shared.show(message: "Error: \(error.localizedDescription)")
                    print("API Error: \(error)")
                }
            }
        }
    }
}


