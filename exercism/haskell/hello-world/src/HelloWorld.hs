module System.Random where

hello = random (mkStdHen 100) :: (Int, StdGen)
