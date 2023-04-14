{-# LANGUAGE NoMonomorphismRestriction #-}
{-# LANGUAGE OverloadedStrings #-}

import First
import System.Environment (getArgs)
import Data.String
import Data.Typeable

main :: IO ()
main = do
  [x] <- getArgs
  --let z = read x :: (Eq a, Read a) => a
  --let z = read x :: (Fractional a, Read a) => a
  let z = read x :: (Typeable a, IsString a, Read a) => a
  --let z = read x :: Double
  --    y = doubleNum $ doubleNum $ doubleNum $ doubleNum z
  print $ typeOf z
  print z

{-
main = do
  [x] <- getArgs
  let z = read' x
      y = doubleNum z
  print y
  where read' :: (Num a, Read a) => String -> a
        read' = read
-}
