//
//  TabBarView.swift
//  TestEgenApp
//
//  Created by Rebecca Zadig on 2022-11-01.
//

import SwiftUI

struct StartView: View {
    var body: some View {
        VStack{
            
            HStack{
                Spacer().frame(width:30)
                Image("BarnensBank")
                    .resizable()
                    .cornerRadius(50)
                    .padding([.leading, .bottom, .trailing])
                    .scaledToFit()
                    .foregroundColor(.accentColor)
                Spacer().frame(width:30)
                
            }
        }
    }
}

struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
    }
}
