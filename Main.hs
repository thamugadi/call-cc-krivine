import Text.Megaparsec (runParser)
import System.Environment (getArgs)
import Show (showKrivine, rnas)
import Parser (parseTerm)
import Krivine (krivine)
import Lambda
import Data.Maybe (listToMaybe)

exec :: String -> Either String [State]
exec s
  | elem ';' s = Left "Don't use semicolons"
  | otherwise  = krivine (runParser parseTerm "" s)

main :: IO ()
main = do
  args <- getArgs
  case listToMaybe args of
    Nothing -> putStrLn "Usage: runghc Main.hs \"<expression>\""
    Just a  -> putStr $ rnas $ showKrivine $ exec a
