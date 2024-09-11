//
//  SystemLogsView.swift
//  ZLensFeedback
//
//  Created by Raghava Dokala on 05/09/24.
//

import Foundation
import SwiftUI

struct SystemLogsView: View {
    var id: Int

    @Binding var isToggled: Bool
    @State private var showView = false
    let viewTitle: String
    let viewButtonTitle: String
    let logContent: String
    var switchAction: ((Int, Bool) -> Void)? // Passes the id and the new state of the switch
    var buttonAction: (() -> Void)? // Passes the id and the new state of the switch
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(viewTitle)
                    .font(.system(size: 14))
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                
                if #available(iOS 16.0, *) {
                    Button(action: {
                        if isKeyboard(){
                            hideKeyboard()
                        }else{
                            showView = true
                            buttonAction?()
                        }
                    }) {
                        Text(viewButtonTitle)
                            .font(.system(size: 12))
                            .foregroundColor(Color(hex: "#089949"))
                    }
                    .popover(isPresented: $showView, content: {
                        ScrollView{
                            VStack(spacing: 10){
                                Text("\(logContent)")
                                    .font(.subheadline)
                                    .padding(10)
                            }
                            .padding (10)
                            .padding(.bottom, 5)
                        }
                    })
                    .presentationDetents([.large])
                } else {
                    // Fallback on earlier versions
                }
            }
            
            Spacer()
            
            CustomSwitchView(id: id, tint: Color(hex: "#089949"), isOn: $isToggled) { _id, status in
                switchAction?(_id,status)
            }
        }
        .padding()
        .background(Color(UIColor.clear))
        
        .overlay(RoundedRectangle(cornerRadius: 10)
            .stroke(Color(hex: "#000000", alpha: 0.12), lineWidth: 2))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    func isKeyboard() ->Bool{
        return UIApplication.shared.sendAction(#selector(getter: UIResponder.isFirstResponder), to: nil, from: nil, for: nil)
    }
}


struct CustomSwitchView: View {
    var id: Int
    var tint: Color
    @Binding var isOn: Bool
    var action: (Int, Bool) -> Void // Passes the id and the new state of the switch

    var body: some View {
        if #available(iOS 17.0, *) {
            Toggle("", isOn: $isOn)
                .onChange(of: isOn) { oldValue, newValue in
                    action(id, newValue)
                }
                .toggleStyle(SwitchToggleStyle(tint: tint))
        }else{
            Toggle("", isOn: $isOn)
                .onChange(of: isOn) { newValue in
                    action(id, newValue)
                }
                .toggleStyle(SwitchToggleStyle(tint: tint))
        }
    }
}
