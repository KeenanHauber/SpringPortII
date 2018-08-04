//
//  SpringFilesDataLoader.swift
//  SpringPort II
//
//  Created by Keenan Hauber on 4/8/18.
//  Copyright © 2018 MasterBel2. All rights reserved.
//

import Foundation



class SLDBDataLoader: LeaderboardLoader, TrueSkillLoader, AccountDetailsLoader {
    
}

protocol LeaderboardLoader {
    
}

protocol TrueSkillLoader {
    
}

protocol AccountDetailsLoader {
    
}

class PlayerStatisticsRepository {
    let leaderboardLoader: LeaderboardLoader
    let trueSkillLoader: TrueSkillLoader
    
    init() {
        let loader = SLDBDataLoader()
        self.leaderboardLoader = loader
        self.trueSkillLoader = loader
    }
}
