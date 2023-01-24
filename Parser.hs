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
parseLambda = lexeme $ do
  _ <- symbol "λ" <|> symbol "lambda" <|> symbol "\\"
  x <- parseVar
  _ <- symbol "."
  e <- parseTerm
  return $ Lambda x e

parseApply :: Parser Term
parseApply = lexeme $ do
  _ <- symbol "("
  a <- parseTerm
  b <- parseTerm
  _ <- symbol ")"
  return $ App a b

parseTerm :: Parser Term
parseTerm = parseApply <|> parseLambda <|> parseCC <|> parseClock <|> parseVar
