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

parseBase :: Parser Type
parseBase = lexeme $ do
  skipMany (symbol "(")
  t <- some alphaNumChar
  skipMany (symbol ")")
  return (Base t)

parseApp :: Parser Type
parseApp = do
  t1 <- parseBase 
  _  <- symbol "->" <|> symbol "→"
  t2 <- parseType 
  return (App t1 t2) 

parseType :: Parser Type
parseType = (try parseApp <|> parseBase)

parseCC :: Parser Term
parseCC = lexeme $ do
  t <- symbol "call/cc"
  return CC

parseVar :: Parser Term 
parseVar = lexeme $ do
  t <- some alphaNumChar
  return (Var t)

parseLambda :: Parser Term
parseLambda = lexeme $ do
  _ <- symbol "λ" <|> symbol "lambda"
  x <- parseVar
  _ <- symbol ":"
  t <- parseType
  _ <- symbol "."
  e <- parseTerm
  return (Lambda x t e)

parseApply2 :: Parser Term
parseApply2 = lexeme $ do
  _ <- symbol "("
  a <- parseApply
  _ <- symbol ")"
  skipMany (symbol "(")
  b <- parseTerm
  skipMany (symbol ")")
  return (Apply a b)

parseApplyL :: Parser Term
parseApplyL = lexeme $ do
  skipMany (symbol "(")
  a <- parseLambda
  skipMany (symbol ")")
  skipMany (symbol "(")
  b <- parseTerm 
  skipMany (symbol ")")
  return (Apply a b)

parseApplyC :: Parser Term
parseApplyC = lexeme $ do
  skipMany (symbol "(")
  a <- parseCC
  b <- parseTerm
  skipMany (symbol ")")
  return (Apply a b)

parseApplyV :: Parser Term
parseApplyV = lexeme $ do
  skipMany (symbol "(")
  a <- parseVar
  b <- parseTerm
  skipMany (symbol ")")
  return (Apply a b)

parseApply :: Parser Term
parseApply = try parseApply2 <|> try parseApplyL <|> parseApplyC 

parseTerm :: Parser Term
parseTerm = (try parseApply) <|> try parseLambda <|> try parseVar <|> parseApplyV
