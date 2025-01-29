/*
 OSM Maps
 Display and use of OSM maps
 Copyright: Michael Rönnau mr@elbe5.de
 */

import SwiftUI

struct HelpView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack{
            Text("helpText".localize())
            Button(action: {
                self.dismiss()
            }) {
                Text("ok".localize())
            }
        }
        .padding()
    }
    
}
    
#Preview {
    HelpView()
}
