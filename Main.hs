import Text.Megaparsec
import System.Environment
import Show
import Parser
import Krivine
import Lambda
import Data.Maybe (listToMaybe)

exec :: String -> Either String [(Term, [Term])]
exec s
  | elem ';' s = Left "Don't use semicolons"
  | otherwise  = krivine (runParser parseTerm "" s)

main :: IO ()
main = do
  args <- getArgs
  case listToMaybe args of
    Nothing -> putStrLn "Usage: runghc Main.hs \"<expression>\""
    Just a  -> putStr $ rnas $ showKrivine $ exec a
