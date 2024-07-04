module DNA (toRNA) where

toRNA :: String -> Either Char String
toRNA str
  | null str = Right ""
  | x `elem` ['G', 'C', 'T', 'A'] = (convert x :) <$> toRNA xs
  | otherwise = Left x
    where x = head str
          xs = tail str

convert :: Char -> Char
convert 'G' = 'C'
convert 'C' = 'G'
convert 'T' = 'A'
convert 'A' = 'U'
