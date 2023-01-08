import Text.Megaparsec
import System.Environment
import Show
import Parser
import Krivine
import Lambda

exec :: String -> Either String [(Term, [Term])]
exec s = krivine (runParser parseTerm "" s)

main :: IO ()
main = do
  args <- getArgs
  putStr $ showKrivine $ exec $ head $ args
