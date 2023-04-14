import First
import System.Environment (getArgs)

main :: IO ()
main = do
  [x] <- getArgs
  let z = read x :: Double
      y = doubleNum z
  print y
