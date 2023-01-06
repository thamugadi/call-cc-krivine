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
parseCC = lexeme $ do
  t <- symbol "call/cc"
  return CC

parseVar :: Parser Term 
parseVar = lexeme $ do
  t <- some alphaNumChar
  return $ Var t

parseLambda :: Parser Term
parseLambda = lexeme $ do
  _ <- symbol "λ" <|> symbol "lambda"
  x <- parseVar
  _ <- symbol "."
  e <- parseTerm
  return $ Lambda x e

parseApply2 :: Parser Term
parseApply2 = lexeme $ do
  _ <- symbol "("
  a <- parseApply
  b <- parseTerm
  _ <- symbol ")"
  return $ Apply a b

parseApplyL :: Parser Term
parseApplyL = lexeme $ do
  _ <- symbol "("
  a <- parseLambda
  b <- parseTerm 
  _ <- symbol ")"
  return $ Apply a b

parseApplyC :: Parser Term
parseApplyC = lexeme $ do
  _ <- symbol "("
  a <- parseCC
  b <- parseTerm
  _ <- symbol ")"
  return $ Apply a b

parseApplyV :: Parser Term
parseApplyV = lexeme $ do
  _ <- symbol "("
  a <- parseVar
  b <- parseTerm
  _ <- symbol ")"
  return $ Apply a b

parseApply :: Parser Term
parseApply = try parseApply2 <|> try parseApplyL <|> try parseApplyC <|> parseApplyV
parseTerm :: Parser Term
parseTerm = try parseApply <|> try parseLambda <|> try parseVar
