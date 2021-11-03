# ---------------------------------------------------------------------------- #
# Paso 0: Limpiar espacio de trabajo ----
# ---------------------------------------------------------------------------- #
rm(list = ls())
# ---------------------------------------------------------------------------- 

# ---------------------------------------------------------------------------- #
# Paso 1: Cargar paquetes necesarios ----
# ---------------------------------------------------------------------------- #
if (!any(rownames(installed.packages()) == 'pacman')) {
  install.packages('pacman')
  library(pacman)
} else {
  cat("Paquete Pacaman instalado")
  library(pacman)
}

pacman::p_load(dplyr, ggplot2, foreign, moments, broom, lmtest)
# -----------------------------------------------------------------------------

# ---------------------------------------------------------------------------- #
# Paso 2: Cargar archivos ----
# ---------------------------------------------------------------------------- #

datos <- foreign::read.dta("./data/TP1.dta")

# -----------------------------------------------------------------------------

# ---------------------------------------------------------------------------- #
# Paso 3: Distribucion de la variable: gasto en alimentos ----
# ---------------------------------------------------------------------------- #

ggplot2::ggplot(data = datos, ggplot2::aes(x = gastoenalimentosyt)) +
  ggplot2::geom_histogram(bins = 5) +
  ggplot2::theme_bw()

# Medidas de dispersion
data.frame(sd = sd(datos$gastoenalimentosyt),
           variancia = var(datos$gastoenalimentosyt),
           kurtosis = moments::kurtosis(datos$gastoenalimentosyt),
           skewness = moments::skewness(datos$gastoenalimentosyt))
# -----------------------------------------------------------------------------

# ---------------------------------------------------------------------------- #
# Paso 4: Distribucion de la variable: ingresos semanales ----
# ---------------------------------------------------------------------------- #

ggplot2::ggplot(data = datos, ggplot2::aes(x = ingresosemanalxt)) +
  ggplot2::geom_histogram(bins = 5) +
  ggplot2::theme_bw()


# Medidas de dispersion
data.frame(sd = sd(datos$ingresosemanalxt),
           variancia = var(datos$ingresosemanalxt),
           kurtosis = moments::kurtosis(datos$ingresosemanalxt),
           skewness = moments::skewness(datos$ingresosemanalxt))
# -----------------------------------------------------------------------------

# ---------------------------------------------------------------------------- #
# Paso 5: Diagrama de dispersión entre variables ----
# ---------------------------------------------------------------------------- #

ggplot2::ggplot(data = datos, ggplot2::aes(x = ingresosemanalxt, y = gastoenalimentosyt)) +
  ggplot2::geom_point() +
  ggplot2::xlab('Ingresos (U$S)') + ggplot2::ylab("Gastos en alimentos") +
  ggplot2::theme_bw()
# -----------------------------------------------------------------------------

# ---------------------------------------------------------------------------- #
# Paso 6: Diagrama de dispersión entre variables ----
# ---------------------------------------------------------------------------- #

ajuste_lineal <- lm(gastoenalimentosyt~ingresosemanalxt,
                    data = datos)

# Evaluacion del ajuste
summary(ajuste_lineal)
# Coeficientes
broom::tidy(ajuste_lineal)
# -----------------------------------------------------------------------------

# ---------------------------------------------------------------------------- #
# Paso 7: Evaluación de residuos: gráfico ----
# ---------------------------------------------------------------------------- #

residuos <- data.frame(residuos = ajuste_lineal$residuals,
                       valores.ajustados = ajuste_lineal$fitted.values)

ggplot2::ggplot(data = residuos, ggplot2::aes(x = valores.ajustados, y = residuos)) +
  ggplot2::geom_point() +
  ggplot2::geom_hline(yintercept = 0, linetype = 'dashed', color = 'DarkOrange') +
  ggplot2::xlab("Valores ajustados") + ggplot2::ylab("Residuos") +
  ggplot2::theme_bw()
# -----------------------------------------------------------------------------

# ---------------------------------------------------------------------------- #
# Paso 8: Evaluación de residuos: test de hipótesis ----
# ---------------------------------------------------------------------------- #
# Breusch-Pagan test
lmtest::bptest(ajuste_lineal) 
# Fox, Weisberg, and Price
car::ncvTest(ajuste_lineal) 
# Goldfeld-Quandt Test
lmtest::gqtest(ajuste_lineal)
# Harrison-McCabe test
lmtest::hmctest(ajuste_lineal)
# -----------------------------------------------------------------------------

# ---------------------------------------------------------------------------- #
# Paso 9: Evaluación de residuos: suma igual a cero ----
# ---------------------------------------------------------------------------- #
residuos %>%
  dplyr::pull(residuos) %>%
  sum() %>%
  round(., 5)
# -----------------------------------------------------------------------------

# ---------------------------------------------------------------------------- #
# Paso 10: Calculo de elastacidad ----
# ---------------------------------------------------------------------------- #
datos %>%
  dplyr::mutate(log_gatos = log(gastoenalimentosyt),
                log_ingresos = log(ingresosemanalxt)) %>%
  do(tidy(lm(log_gatos~log_ingresos, data = .)))
# -----------------------------------------------------------------------------

# ---------------------------------------------------------------------------- #
# Paso 11: Prediccion de valores ----
# ---------------------------------------------------------------------------- #
predict(ajuste_lineal, data.frame(ingresosemanalxt = 750))
# -----------------------------------------------------------------------------
