{-# LANGUAGE OverloadedStrings #-}
module Parser where

import Data.Void   
import Control.Monad (void)
import Text.Megaparsec
import Text.Megaparsec.Char
import qualified Text.Megaparsec.Char.Lexer as L

import Lambda

type Parser = Parsec Void String 

sc :: Parser ()
sc = L.space (void $ some (char ' ' <|> char '\t')) empty empty

lexeme :: Parser a -> Parser a
lexeme = L.lexeme sc

symbol :: String -> Parser String
symbol = L.symbol sc

parseVar :: Parser Term
parseVar = lexeme $ Var <$> some alphaNumChar

parseLambda :: Parser Term
parseLambda = lexeme $ lambda *> (mulLambda <$> some parseVar <* symbol ".") <*> parseTerm where
  lambda = symbol "λ" <|> symbol "lambda" <|> symbol "\\"

parseParens :: Parser Term
parseParens = between (symbol "(") (symbol ")") parseTerm

parseAtom :: Parser Term
parseAtom = parseVar <|> parseLambda <|> parseParens

parseApply :: Parser Term
parseApply = foldl1 App <$> some parseAtom

parseTerm :: Parser Term
parseTerm = (many $ char ' ') *> parseApply
