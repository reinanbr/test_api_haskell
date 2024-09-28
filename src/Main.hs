{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE OverloadedStrings #-}

module Main where

import Data.Aeson (FromJSON, ToJSON)
import Data.Text (Text)
import GHC.Generics (Generic)
import Network.Wai (Application)
import Network.Wai.Handler.Warp (run)
import Servant

-- Definir o tipo de API: GET em "/hello" e POST em "/greet"
type API = 
       "hello" :> Get '[PlainText] Text
  :<|> "greet" :> ReqBody '[JSON] GreetRequest :> Post '[JSON] GreetResponse

-- Definir os tipos de dados para o POST
data GreetRequest = GreetRequest
  { name :: Text }
  deriving (Generic, FromJSON)

data GreetResponse = GreetResponse
  { message :: Text }
  deriving (Generic, ToJSON)

-- Implementar os manipuladores da API
server :: Server API
server = 
       return "Hello, World!"
  :<|> greetHandler

greetHandler :: GreetRequest -> Handler GreetResponse
greetHandler (GreetRequest name) = return $ GreetResponse ("Hello, " <> name <> "!")

-- Transformar a API em uma aplicação WAI
app :: Application
app = serve (Proxy :: Proxy API) server

-- Função principal para rodar o servidor
main :: IO ()
main = do
  putStrLn "Starting server on port 8080..."
  run 8080 app

