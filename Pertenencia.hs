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
simpl er  | er == (simplCom er) = er | otherwise = simpl (simplCom er)

-- EJERCICIO 2
denot :: ExpReg -> Lenguaje
denot = nub . denotAuxiliar . simpl

-- EJERCICIO 3
enLeng :: String -> ExpReg -> Bool
enLeng s er = s `elem` (denot er) 

------------------- DERIVADAS -----------------------

-- EJERCICIO 4
--Función que calcula la derivada de una ER con respecto de una cadena
derivadaCad :: String -> ExpReg -> ExpReg
derivadaCad "" r = simpl r
derivadaCad w r = derivadaCad (tail w) (derivadaSim (head w) r)

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
denotAuxiliar (Star er) = take 1000 (concat potencias)
  where
    lenguaje = denot er
    potenciaN leng = [x ++ y | x <- leng, y <- lenguaje]
    potencias = iterate potenciaN [""]
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

-- simplCom nos permite simplificar una expresion regular.
-- Es
simplCom :: ExpReg -> ExpReg
simplCom Void = Void
simplCom Epsilon = Epsilon
simplCom (Symbol a) = Symbol a

simplCom (Star Void) = Epsilon
simplCom (Star Epsilon) = Epsilon
simplCom (Star (Star er)) = simplCom (Star er)
simplCom (Star er) = Star (simplCom er)

simplCom (Concat Epsilon er2) = simplCom er2
simplCom (Concat er1 Epsilon) = simplCom er1
simplCom (Concat Void er2) = Void
simplCom (Concat er1 Void) = Void
simplCom (Concat (Star er1) (Star er2)) | er1 == er2 = simplCom (Star er1)
simplCom (Concat er1 er2) = Concat (simplCom er1) (simplCom er2)

simplCom (Add er1 er2) | er1 == er2 = simplCom er1
simplCom (Add Void er) = simplCom er
simplCom (Add er Void) = simplCom er
simplCom (Add er1 er2) = Add (simplCom er1) (simplCom er2)

-- Ejemplos:
-- Cadenas:
w1 = "10110100"
w2 = "abaabb"
w3 = "Hola"

-- Expresiones regulares:
er1 = (Star (Add (Concat (Symbol '1') (Symbol '0')) (Concat (Symbol '1') (Symbol '1'))))
er2 = (Star (Star (Star (Symbol 'z'))))
er3 = (Star (Add (Symbol 'a') (Add (Symbol 'b') (Symbol 'c'))))
er4 = (Concat (Star (Symbol 'b')) (Add (Symbol 'a') (Symbol 'c')))
er5 = (Star (Add (Star (Epsilon)) (Star (Concat (Symbol 'a') (Void)))))

er6 = (Concat (Star (Add Epsilon (Add Void (Add (Concat Epsilon (Star (Concat Void (Symbol '0')))) (Star (Concat (Symbol '0') (Concat Epsilon (Symbol '1')))))))) Void)

-- Funciones:
simpl1 = simpl er1
-- simpl1 = er1

simpl2 = simpl er2
-- simpl2 = Star Symbol 'z'

simpl3 = simpl er3
-- simpl3 = er3

simpl4 = simpl er4
-- simpl4 = er4

simpl5 = simpl er5
-- simpl5 = Epsilon

denot1 = denot er1
-- denot1 = [ , 10, 11, 1010, 1011, 1110, 1111, ....]

denot2 = denot er2
-- denot2 = [ , z, zz, zzz, zzzz, .......]

denot3 = denot er3
-- denot3 = [ , a, b, c, aa, ab, ac, ba, bb, bc, ca, cb, cc, ......]

denot4 = denot er4
-- denot4 = [a, c, ba, bc, bba, bbc, ......]

denot5 = denot er5
-- denot5 = [""]

enLeng1 = enLeng "abcab" er3
-- enLeng = True

enLeng2 = enLeng "10111011" er1
-- enLeng = True

enLeng3 = enLeng "zazbasdfz" er2
-- enLeng = False

enLeng4 = enLeng "" er4
-- enLeng = False

enLeng5 = enLeng "cbbabac" er3
-- enLeng = False

derivadaCad1 = derivadaCad w1 er1
-- derivadaCad1 = Void

derivadaCad2 = derivadaCad w2 er3
-- derivadaCad2 = er3

derivadaCad3 = derivadaCad w3 (Star (Add (Concat (Symbol 'H') (Symbol 'o')) (Concat (Symbol 'l') (Symbol 'a'))))
-- Regresa la misma expresion regular

enLengDeriv1 = enLengDeriv w1 er1
-- False

enLengDeriv2 = enLengDeriv "10111011" er1
-- True

enLengDeriv3 = enLengDeriv w2 er3
-- True
