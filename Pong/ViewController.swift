//
//  ViewController.swift
//  AppOne
//
//  Created by Karol Borecki on 26/09/2018.
//  Copyright © 2018 Karol Borecki. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var refreshBtn: UIButton!
    @IBOutlet var mainView: UIView!
    
    @IBOutlet weak var player1: UIImageView!
    @IBOutlet weak var player2: UIImageView!
    
    @IBOutlet weak var player2Lbl: UILabel!
    @IBOutlet weak var player1Lbl: UILabel!

    @IBOutlet weak var ball: UIImageView!
    
    let screenHeight = UIScreen.main.bounds.height
    let screenWidth = UIScreen.main.bounds.width
    
    var isGameActive = false
    var ballVectorX = -1.0
    var ballVectorY = -1.0
    
    var gameTimer: Timer!
    let timerInterval = 0.003
    var ballPosChangeValue = 0.8
    
    var player1Score = 0
    var player2Score = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ball.layer.cornerRadius = ball.frame.height/2
    }
    
    func playTheBall() {
        ball.isHidden = false
        gameTimer = Timer.scheduledTimer(timeInterval: timerInterval, target: self, selector: #selector(updateBallPos), userInfo: nil, repeats: true)
    }
    
    func resetBall() {
        ball.isHidden = true
        ball.center.x = screenWidth/2
        ball.center.y = screenHeight/2
    }
    
    @objc
    func updateBallPos() {
        setBallVector()
        
        ball.center.y += CGFloat(ballPosChangeValue * ballVectorY)
        ball.center.x += CGFloat(ballPosChangeValue * ballVectorX)
    }
    
    func setBallVector() {
        if ball.center.x >= screenWidth {
            ballVectorX = -1.0
        }
        if ball.center.x <= 0 {
            ballVectorX = 1.0
        }
        
        if ball.center.y + ball.frame.height/2 >= player1.center.y + player2.frame.height/2 {
            checkPaddle(player1)
        }
        if ball.center.y - ball.frame.height/2 <= player2.center.y + player2.frame.height/2 {
            checkPaddle(player2)
        }
    }
    
    func checkPaddle(_ paddle:UIImageView!) {
        let paddleRightEnd = paddle.center.x + paddle.frame.width/2
        let paddleLeftEnd = paddle.center.x - paddle.frame.width/2
        
        if ball.center.x <= paddleRightEnd && ball.center.x >= paddleLeftEnd {
            ballVectorY = -ballVectorY
            ballPosChangeValue += 0.02
        } else {
            if paddle.center.y > screenHeight/2 {
                player2Score += 1
                player2Lbl.text = String(player2Score)
            } else {
                player1Score += 1
                player1Lbl.text = String(player1Score)
            }
            ballVectorY = -ballVectorY
            endGame()
            playTheBall()
        }
    }
    
    func endGame() {
        ballPosChangeValue = 0.6
        gameTimer.invalidate()
        resetBall()
    }
    
    @IBAction func platBtnPressed(_ sender: Any) {
        if !self.isGameActive{
            playBtn.isHidden = true
            playBtn.isEnabled = false
            refreshBtn.isEnabled = true
            self.isGameActive = true
            self.playTheBall()
        }
    }

    @IBAction func refreshBtnPressed(_ sender: Any) {
        endGame()
        playBtn.isHidden = false
        playBtn.isEnabled = true
        refreshBtn.isEnabled = false
        isGameActive = false
        player1Score = 0
        player2Score = 0
        player1Lbl.text = "0"
        player2Lbl.text = "0"
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if self.isGameActive{
                let position = touch.location(in: mainView)
                
                if position.y > screenHeight/2{
                    player1.center.x = position.x
                } else {
                    player2.center.x = position.x
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if self.isGameActive{
                let position = touch.location(in: mainView)
                
                if position.y > screenHeight/2{
                    player1.center.x = position.x
                } else {
                    player2.center.x = position.x
                }
            }
        }
    }
    
}

