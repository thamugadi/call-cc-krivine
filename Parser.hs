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

parseCC :: Parser Term
parseCC = lexeme $ symbol "call/cc" *> return CC

parseClock :: Parser Term
parseClock = lexeme $ symbol "clock" *> return Clock

parseVar :: Parser Term
parseVar = lexeme $ Var <$> some alphaNumChar

parseLambda :: Parser Term
parseLambda = lexeme $ lambda *> (Lambda <$> parseVar <* symbol "." <*> parseTerm) where
  lambda = symbol "λ" <|> symbol "lambda" <|> symbol "\\"

parseApply :: Parser Term
parseApply = lexeme $ symbol "(" *> (App <$> parseTerm <*> parseTerm) <* symbol ")"

parseTerm :: Parser Term
parseTerm = parseApply <|> parseLambda <|> parseCC <|> parseClock <|> parseVar
