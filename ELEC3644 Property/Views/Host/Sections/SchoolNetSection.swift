//
//  SchoolNetSection.swift
//  ELEC3644 Property
//
//  Created by Filbert Tejalaksana on 30/10/2024.
//

import SwiftUI

struct SchoolNetSection: View {
    @Binding var primarySchoolNet: String
    @Binding var secondarySchoolNet: String
    
    var body: some View {
        Form {
            Section(header: Text("School Net")) {
                TextField("Primary School Net", text: $primarySchoolNet)
                TextField("Secondary School Net", text: $secondarySchoolNet)
            }
        }
    }
}

struct SchoolNetSection_Previews: PreviewProvider {
    static var previews: some View {
        SchoolNetSection(primarySchoolNet: .constant(""), secondarySchoolNet: .constant(""))
    }
}
