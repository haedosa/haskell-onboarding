module Bob (responseFor) where

import Data.Char (isUpper, toUpper, isLetter, isSpace)

responseFor :: String -> String
responseFor xs
  | silence = "Fine. Be that way!"
  | question && yell = "Calm down, I know what I'm doing!"
  | yell = "Whoa, chill out!"
  | question =  "Sure."
  | otherwise = "Whatever."
  where
    question = last (filter (not . isSpace) xs) == '?'
    yell = map toUpper xs == xs && any isLetter xs
    silence = all isSpace xs || null xs
