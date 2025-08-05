//
//  MusicSourceStrategy.swift
//  FlexPlayer
//
//  Created by admin25 on 06/08/25.
//
import Foundation

protocol MusicSourceStrategy
{
 
    var type: MusicSourceType { get }

    func loadSongs(completion: @escaping ([Song]) -> Void)
}
