//
//  Fonts04.swift
//  C4Examples
//
//  Created by Oliver Andrews on 2015-09-08.
//  Copyright © 2015 Slant. All rights reserved.
//

import C4

class Fonts04: CanvasController {
    override func setup() {
        //will print to the console ALL the family names of availble fonts
        let familyNames = Font.familyNames()
        
        for strings in familyNames {
            print(strings)
        }
    }
}
