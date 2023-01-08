import Text.Megaparsec
import System.Environment
import Show
import Parser
import Krivine
exec s = krivine (runParser parseTerm "" s)

main :: IO ()
main = do
  args <- getArgs
  putStr $ showKrivine $ exec $ head $ args
