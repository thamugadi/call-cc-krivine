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
parseVar = lexeme $ Var <$> some (alphaNumChar <|> char '/')

parseLambda :: Parser Term
parseLambda = lexeme $ symbol "\\" *> (mulLambda <$> some parseVar <* symbol ".") <*> parseTerm

parseParens :: Parser Term
parseParens = symbol "(" *> parseTerm <* symbol ")"

parseAtom :: Parser Term
parseAtom = parseCont <|> parseVar <|> parseLambda <|> parseParens

parseCont :: Parser Term
parseCont = lexeme $ (optional $ symbol "continuation") *> parseCont1

parseCont1 :: Parser Term
parseCont1 = Cont <$> (symbol "[" *> sepBy parseTerm (symbol ",") <* symbol "]")

parseApply :: Parser Term
parseApply = foldl1 App <$> some parseAtom

parseTerm :: Parser Term
parseTerm = (many $ char ' ') *> parseApply
