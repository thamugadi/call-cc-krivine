import Text.Megaparsec
import System.Environment
import Show
import Parser
import Krivine
import Lambda

exec :: String -> Either String [(Term, [Term])]
exec s
  | elem ';' s = Left "Don't use semicolons"
  | otherwise = krivine (runParser parseTerm "" s)

main :: IO ()
main = do
  args <- getArgs
  putStr $ rnas $ showKrivine $ exec $ head $ args
