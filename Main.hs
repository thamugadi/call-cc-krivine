import System.Environment (getArgs)
import Show (showKrivine)
import Krivine 
import Data.Maybe (listToMaybe)

main :: IO ()
main = do
  args <- getArgs
  case listToMaybe args of
    Nothing -> putStrLn "Usage: runghc Main.hs \"<expression>\""
    Just a  -> putStr $ showKrivine $ runKrivine a []
