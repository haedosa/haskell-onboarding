module Darts (score) where

score :: Float -> Float -> Int
score x y
  | dist <= 1 = 10
  | dist <= 5 = 5
  | dist <= 10 = 1
  | otherwise = 0
  where dist = sqrt $ x ** 2 + y ** 2
