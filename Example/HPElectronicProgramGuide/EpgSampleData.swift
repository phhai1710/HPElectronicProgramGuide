//
//  EpgSampleData.swift
//  HPElectronicProgramGuide
//
//  Created by Hai Pham on 02/24/2024.
//  Copyright (c) 2024 Hai Pham. All rights reserved.
//

import Foundation

struct EpgProgram {
    let programName: String
    let fromSecond: Int
    let toSecond: Int
}

final class EpgSampleData {
    
    let channels: [String] = ["HBO", "Fox", "Disney", "NBC", "CNN", "News", "TNT", "AMC", "Univison", "Abc", "LivingTV", "Bloomberg", "Cartoon", "BBC", "Discovery", "PBS", "Channel 17", "VTV", "Cinemax", "Fashion"]
    let programs: [[EpgProgram]] = [
        [
            EpgProgram(programName: "Friends", fromSecond: 0, toSecond: 900),
            EpgProgram(programName: "The Big Bang Theory", fromSecond: 900, toSecond: 3500),
            EpgProgram(programName: "Game of Thrones", fromSecond: 3500, toSecond: 5400),
            EpgProgram(programName: "Breaking Bad", fromSecond: 5400, toSecond: 6300),
            EpgProgram(programName: "Stranger Things", fromSecond: 6300, toSecond: 7800),
            EpgProgram(programName: "The Office", fromSecond: 7800, toSecond: 10000),
            EpgProgram(programName: "No program", fromSecond: 10000, toSecond: 86400)
        ],
        [
            EpgProgram(programName: "Grey's Anatomy", fromSecond: 0, toSecond: 900),
            EpgProgram(programName: "The Simpsons", fromSecond: 900, toSecond: 2000),
            EpgProgram(programName: "NCIS", fromSecond: 2000, toSecond: 3000),
            EpgProgram(programName: "No program", fromSecond: 3000, toSecond: 86400)
        ],
        [
            EpgProgram(programName: "How I Met Your Mother", fromSecond: 0, toSecond: 1500),
            EpgProgram(programName: "Supernatural", fromSecond: 1500, toSecond: 3000),
            EpgProgram(programName: "Stranger Things", fromSecond: 3000, toSecond: 5000),
            EpgProgram(programName: "The Walking Dead", fromSecond: 5000, toSecond: 7000),
            EpgProgram(programName: "The Office", fromSecond: 7000, toSecond: 9000),
            EpgProgram(programName: "Breaking Bad", fromSecond: 9000, toSecond: 10000),
            EpgProgram(programName: "No program", fromSecond: 10000, toSecond: 86400)
        ],
        [
            EpgProgram(programName: "Game of Thrones", fromSecond: 0, toSecond: 1800),
            EpgProgram(programName: "Friends", fromSecond: 1800, toSecond: 3600),
            EpgProgram(programName: "The Big Bang Theory", fromSecond: 3600, toSecond: 5000),
            EpgProgram(programName: "No program", fromSecond: 5000, toSecond: 86400)
        ],
        [
            EpgProgram(programName: "The Simpsons", fromSecond: 0, toSecond: 1000),
            EpgProgram(programName: "Family Guy", fromSecond: 1000, toSecond: 2000),
            EpgProgram(programName: "South Park", fromSecond: 2000, toSecond: 3000),
            EpgProgram(programName: "American Dad!", fromSecond: 3000, toSecond: 4000),
            EpgProgram(programName: "Bob's Burgers", fromSecond: 4000, toSecond: 5000),
            EpgProgram(programName: "Futurama", fromSecond: 5000, toSecond: 6000),
            EpgProgram(programName: "No program", fromSecond: 6000, toSecond: 86400)
        ],
        [
            EpgProgram(programName: "Breaking Bad", fromSecond: 0, toSecond: 1000),
            EpgProgram(programName: "Stranger Things", fromSecond: 1000, toSecond: 3000),
            EpgProgram(programName: "Game of Thrones", fromSecond: 3000, toSecond: 4000),
            EpgProgram(programName: "Friends", fromSecond: 4000, toSecond: 5000),
            EpgProgram(programName: "The Office", fromSecond: 5000, toSecond: 6000),
            EpgProgram(programName: "No program", fromSecond: 6000, toSecond: 86400)
        ],
        [
            EpgProgram(programName: "Friends", fromSecond: 0, toSecond: 900),
            EpgProgram(programName: "The Big Bang Theory", fromSecond: 900, toSecond: 3500),
            EpgProgram(programName: "Game of Thrones", fromSecond: 3500, toSecond: 5400),
            EpgProgram(programName: "Breaking Bad", fromSecond: 5400, toSecond: 6300),
            EpgProgram(programName: "Stranger Things", fromSecond: 6300, toSecond: 7800),
            EpgProgram(programName: "The Office", fromSecond: 7800, toSecond: 10000),
            EpgProgram(programName: "No program", fromSecond: 10000, toSecond: 86400)
        ],
        [
            EpgProgram(programName: "Grey's Anatomy", fromSecond: 0, toSecond: 900),
            EpgProgram(programName: "The Simpsons", fromSecond: 900, toSecond: 2000),
            EpgProgram(programName: "NCIS", fromSecond: 2000, toSecond: 3000),
            EpgProgram(programName: "No program", fromSecond: 3000, toSecond: 86400)
        ],
        [
            EpgProgram(programName: "How I Met Your Mother", fromSecond: 0, toSecond: 1500),
            EpgProgram(programName: "Supernatural", fromSecond: 1500, toSecond: 3000),
            EpgProgram(programName: "Stranger Things", fromSecond: 3000, toSecond: 5000),
            EpgProgram(programName: "The Walking Dead", fromSecond: 5000, toSecond: 7000),
            EpgProgram(programName: "The Office", fromSecond: 7000, toSecond: 9000),
            EpgProgram(programName: "Breaking Bad", fromSecond: 9000, toSecond: 10000),
            EpgProgram(programName: "No program", fromSecond: 10000, toSecond: 86400)
        ],
        [
            EpgProgram(programName: "Game of Thrones", fromSecond: 0, toSecond: 1800),
            EpgProgram(programName: "Friends", fromSecond: 1800, toSecond: 3600),
            EpgProgram(programName: "The Big Bang Theory", fromSecond: 3600, toSecond: 5000),
            EpgProgram(programName: "No program", fromSecond: 5000, toSecond: 86400)
        ],
        [
            EpgProgram(programName: "The Simpsons", fromSecond: 0, toSecond: 1000),
            EpgProgram(programName: "Family Guy", fromSecond: 1000, toSecond: 2000),
            EpgProgram(programName: "South Park", fromSecond: 2000, toSecond: 3000),
            EpgProgram(programName: "American Dad!", fromSecond: 3000, toSecond: 4000),
            EpgProgram(programName: "Bob's Burgers", fromSecond: 4000, toSecond: 5000),
            EpgProgram(programName: "Futurama", fromSecond: 5000, toSecond: 6000),
            EpgProgram(programName: "No program", fromSecond: 6000, toSecond: 86400)
        ],
        [
            EpgProgram(programName: "Breaking Bad", fromSecond: 0, toSecond: 1000),
            EpgProgram(programName: "Stranger Things", fromSecond: 1000, toSecond: 3000),
            EpgProgram(programName: "Game of Thrones", fromSecond: 3000, toSecond: 4000),
            EpgProgram(programName: "Friends", fromSecond: 4000, toSecond: 5000),
            EpgProgram(programName: "The Office", fromSecond: 5000, toSecond: 6000),
            EpgProgram(programName: "No program", fromSecond: 6000, toSecond: 86400)
        ],
        [
            EpgProgram(programName: "Friends", fromSecond: 0, toSecond: 900),
            EpgProgram(programName: "The Big Bang Theory", fromSecond: 900, toSecond: 3500),
            EpgProgram(programName: "Game of Thrones", fromSecond: 3500, toSecond: 5400),
            EpgProgram(programName: "Breaking Bad", fromSecond: 5400, toSecond: 6300),
            EpgProgram(programName: "Stranger Things", fromSecond: 6300, toSecond: 7800),
            EpgProgram(programName: "The Office", fromSecond: 7800, toSecond: 10000),
            EpgProgram(programName: "No program", fromSecond: 10000, toSecond: 86400)
        ],
        [
            EpgProgram(programName: "Grey's Anatomy", fromSecond: 0, toSecond: 900),
            EpgProgram(programName: "The Simpsons", fromSecond: 900, toSecond: 2000),
            EpgProgram(programName: "NCIS", fromSecond: 2000, toSecond: 3000),
            EpgProgram(programName: "No program", fromSecond: 3000, toSecond: 86400)
        ],
        [
            EpgProgram(programName: "How I Met Your Mother", fromSecond: 0, toSecond: 1500),
            EpgProgram(programName: "Supernatural", fromSecond: 1500, toSecond: 3000),
            EpgProgram(programName: "Stranger Things", fromSecond: 3000, toSecond: 5000),
            EpgProgram(programName: "The Walking Dead", fromSecond: 5000, toSecond: 7000),
            EpgProgram(programName: "The Office", fromSecond: 7000, toSecond: 9000),
            EpgProgram(programName: "Breaking Bad", fromSecond: 9000, toSecond: 10000),
            EpgProgram(programName: "No program", fromSecond: 10000, toSecond: 86400)
        ],
        [
            EpgProgram(programName: "Game of Thrones", fromSecond: 0, toSecond: 1800),
            EpgProgram(programName: "Friends", fromSecond: 1800, toSecond: 3600),
            EpgProgram(programName: "The Big Bang Theory", fromSecond: 3600, toSecond: 5000),
            EpgProgram(programName: "No program", fromSecond: 5000, toSecond: 86400)
        ],
        [
            EpgProgram(programName: "The Simpsons", fromSecond: 0, toSecond: 1000),
            EpgProgram(programName: "Family Guy", fromSecond: 1000, toSecond: 2000),
            EpgProgram(programName: "South Park", fromSecond: 2000, toSecond: 3000),
            EpgProgram(programName: "American Dad!", fromSecond: 3000, toSecond: 4000),
            EpgProgram(programName: "Bob's Burgers", fromSecond: 4000, toSecond: 5000),
            EpgProgram(programName: "Futurama", fromSecond: 5000, toSecond: 6000),
            EpgProgram(programName: "No program", fromSecond: 6000, toSecond: 86400)
        ],
        [
            EpgProgram(programName: "Breaking Bad", fromSecond: 0, toSecond: 1000),
            EpgProgram(programName: "Stranger Things", fromSecond: 1000, toSecond: 3000),
            EpgProgram(programName: "Game of Thrones", fromSecond: 3000, toSecond: 4000),
            EpgProgram(programName: "Friends", fromSecond: 4000, toSecond: 5000),
            EpgProgram(programName: "The Office", fromSecond: 5000, toSecond: 6000),
            EpgProgram(programName: "No program", fromSecond: 6000, toSecond: 86400)
        ],
        [
            EpgProgram(programName: "The Simpsons", fromSecond: 0, toSecond: 1000),
            EpgProgram(programName: "Family Guy", fromSecond: 1000, toSecond: 2000),
            EpgProgram(programName: "South Park", fromSecond: 2000, toSecond: 3000),
            EpgProgram(programName: "American Dad!", fromSecond: 3000, toSecond: 4000),
            EpgProgram(programName: "Bob's Burgers", fromSecond: 4000, toSecond: 5000),
            EpgProgram(programName: "Futurama", fromSecond: 5000, toSecond: 6000),
        ],
        [
            EpgProgram(programName: "Breaking Bad", fromSecond: 0, toSecond: 1000),
            EpgProgram(programName: "Stranger Things", fromSecond: 1000, toSecond: 3000),
            EpgProgram(programName: "Game of Thrones", fromSecond: 3000, toSecond: 4000),
            EpgProgram(programName: "Friends", fromSecond: 4000, toSecond: 5000),
            EpgProgram(programName: "The Office", fromSecond: 5000, toSecond: 6000),
        ]
    ]
}
