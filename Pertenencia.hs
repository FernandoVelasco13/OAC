{-
- Universidad Nacional Autónoma de México
- Autómatas y Lenguajes Formales 2026-I
- Proyecto 2 
- Representación y Pertenencia a un lenguaje
- Autor: Fernando Velasco Gutierrez

- Programa que dada una cadena w y una expresión regular r, 
- indica si la cadena w pertenece a L[r].
- Para esto se usan la técnicas, denotación de expresiones regulares,
- así como la definición de funciones básicas entre lenguajes y expresiones regulares.
- También que dada una cadena w y una expresión regular r, 
- calcula la derivada de la cadena w con respecto a la 
- expresión regular r, ∂w(r).
- Para esto se usan la técnicas de derivada de una expresión 
- regular con respecto a un símbolo, la cual se extenderá 
- recursivamente a cadenas, así como la definición de nulidad y pertenencia.
-}

module Pertenencia where

import Data.List

-- Tipo de dato algebraico para representar Expresiones Regulares
data ExpReg = Void
            | Epsilon
            | Symbol Char           -- El símbolo representado por el caracter que recibe
            | Star ExpReg           -- r*
            | Concat ExpReg ExpReg  -- (rs)
            | Add ExpReg ExpReg     -- (r + s)
            deriving (Eq)

-- Sinónimo para representar lenguajes como listas de cadenas.
type Lenguaje = [String]

 -- Instancia de Show del tipo Regex, para que se impriman con formato en la consola. 
instance Show ExpReg where
   show Void = "ø"
   show Epsilon = "ε"
   show (Symbol c) = c:[]
   show (Star r) = show r ++ "*"
   show (Concat r s) = "(" ++ show r ++ show s ++ ")"
   show (Add r s) = "(" ++ show r ++ " + " ++ show s ++ ")"

------------------- DENOTACIÓN -----------------------

-- EJERCICIO 1
simpl :: ExpReg -> ExpReg
simpl Void = Void
simpl Epsilon = Epsilon
simpl (Symbol a) = Symbol a

simpl (Star Void) = Epsilon
simpl (Star Epsilon) = Epsilon
simpl (Star (Star er)) = simpl (Star er)
simpl (Star er) = Star (simpl er)

simpl (Concat Epsilon er2) = simpl er2
simpl (Concat er1 Epsilon) = simpl er1
simpl (Concat Void _) = Void
simpl (Concat _ Void) = Void
simpl (Concat (Star er1) (Star er2)) | er1 == er2 = simpl (Star er1)
simpl (Concat er1 er2) = Concat (simpl er1) (simpl er2)

simpl (Add er1 er2) | er1 == er2 = simpl er1
simpl (Add Void er) = simpl er
simpl (Add er Void) = simpl er
simpl (Add er1 er2) = Add (simpl er1) (simpl er2)


-- EJERCICIO 2
denot :: ExpReg -> Lenguaje
denot = denotAuxiliar . simpl

-- EJERCICIO 3
enLeng :: String -> ExpReg -> Bool
enLeng s er = s `elem` (denot er) 

------------------- DERIVADAS -----------------------

-- EJERCICIO 4
--Función que calcula la derivada de una ER con respecto de una cadena
derivadaCad :: String -> ExpReg -> ExpReg
derivadaCad "" r = r
derivadaCad w r = derivadaCad (init w) (derivadaSim (last w) r)

-- EJERCICIO 5
--Funcion que verifica si r~u, pertenencia de una cadena en L[r] por medio de la derivada de ER
enLengDeriv :: String -> ExpReg -> Bool
enLengDeriv w r = "" `elem` (denot (derivadaCad w r))

-- Funciones Auxiliares

-- denotAuxiliar nos permite generar el lenguaje dada una expresion regular, pero con una expresion regular simplificada.
-- Por lo que es necesario para hacer composicion de funciones en denot.
denotAuxiliar :: ExpReg -> Lenguaje
denotAuxiliar Void = []
denotAuxiliar Epsilon = [""]
denotAuxiliar (Symbol a) = [[a]]
denotAuxiliar (Star er) = [""] ++ [x ++ y | x <- denotAuxiliar er, y <- denotAuxiliar (Star er)]
denotAuxiliar (Concat er1 er2) = [x ++ y | x <- denotAuxiliar er1, y <- denotAuxiliar er2]
denotAuxiliar (Add er1 er2) = (denotAuxiliar er1) `union` (denotAuxiliar er2)

-- nulidad nos permite calcular si una ER es anulable o no.
-- Es necesaria para realizar el calculo de la derivada de una ER con respecto a un simbolo.
nulidad :: ExpReg -> ExpReg
nulidad Void = Void
nulidad Epsilon = Epsilon
nulidad (Symbol a) = Void
nulidad (Add er1 er2) = simpl (Add (nulidad er1) (nulidad er2))
nulidad (Concat er1 er2) = simpl (Concat (nulidad er1) (nulidad er2))
nulidad (Star er) = Epsilon

-- derivadaSim nos permite calcular la derivada de una ER con respector de un simbolo.
-- Es necesario para la funcion derivadaCad.
derivadaSim :: Char -> ExpReg -> ExpReg
derivadaSim a Void = Void
derivadaSim a Epsilon = Void
derivadaSim a (Symbol b) | a == b = Epsilon | otherwise = Void
derivadaSim a (Add er1 er2) = simpl (Add (derivadaSim a er1) (derivadaSim a er2))
derivadaSim a (Concat er1 er2) = simpl (Add (Concat (derivadaSim a er1) er2) (Concat (nulidad er1) (derivadaSim a er2)))
derivadaSim a (Star er) = simpl (Concat (derivadaSim a er) (Star er))
