module First where

doubleNum :: (Num a) => a -> a
doubleNum x = 2 * x

doubleSmallNumber x =
  if x > 100
  then
    x
  else
    x + x

a = [ 1, 2, 3, 4, 5, 6 ]

aInit  = init a

millionMillonFive = take 6 (drop 9999 [1..])

listOfList = [ [1 , 2], [3.9 , 5.3 , 7.1] ]

listCon = [ x | x <- [10..20], x /= 13, x /= 15]


-- ghci -isrc
-- :l First

listCom = [ x**2 | x <- [1,2..], x < 10]

boomBang xs = [ if x < 10 then "Boom" else "Bang" | x <- xs, odd x]

modSeven xs = [x| x<-xs, x `mod` 7 == 3]

modSevenAnswer = modSeven [50..100]
