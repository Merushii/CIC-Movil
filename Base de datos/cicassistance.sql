-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 19-05-2024 a las 09:58:36
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `cicassistance`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `asignaciones`
--

CREATE TABLE `asignaciones` (
  `IdAsignacion` int(11) NOT NULL,
  `IdSolicitud` int(11) NOT NULL,
  `IdTecnico` int(11) NOT NULL,
  `DIagnostico` text NOT NULL,
  `Solucion` text NOT NULL,
  `Encuesta` text NOT NULL,
  `Mensaje` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `dictamenes`
--

CREATE TABLE `dictamenes` (
  `idDictamen` int(11) NOT NULL,
  `FolioSolicitud` int(11) NOT NULL,
  `idVale` int(11) NOT NULL,
  `Fecha` varchar(50) NOT NULL,
  `Equipo` varchar(50) NOT NULL,
  `NoSerieEquipo` varchar(50) NOT NULL,
  `MarcaEquipo` varchar(50) NOT NULL,
  `ModeloEquipo` varchar(50) NOT NULL,
  `Descripcion` varchar(250) NOT NULL,
  `Observaciones` varchar(250) NOT NULL,
  `Encargado` varchar(50) NOT NULL,
  `Estado` enum('Vigente','Obsoleto') NOT NULL,
  `DictamenFinal` enum('Funciona','No Funciona','Baja') NOT NULL,
  `caracDictamen` varchar(200) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `edificios`
--

CREATE TABLE `edificios` (
  `IdEdificio` int(11) NOT NULL,
  `NombreEdificio` varchar(60) NOT NULL,
  `Nivel` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `edificios`
--

INSERT INTO `edificios` (`IdEdificio`, `NombreEdificio`, `Nivel`) VALUES
(1, 'A', 1),
(2, 'A', 2),
(3, 'A', 3),
(4, 'B', 1),
(5, 'B', 2),
(6, 'B', 3),
(7, 'C', 1),
(8, 'C', 2),
(9, 'C', 3),
(10, 'D', 1),
(11, 'D', 2),
(12, 'D', 3),
(13, 'E', 1),
(14, 'E', 2),
(15, 'E', 3),
(16, 'F', 1),
(17, 'F', 2),
(18, 'F', 3),
(19, 'G', 1),
(20, 'G', 2),
(21, 'G', 3),
(22, 'H', 1),
(23, 'H', 2),
(24, 'H', 3),
(25, 'I', 1),
(26, 'I', 2),
(27, 'I', 3),
(28, 'J', 1),
(29, 'K', 1),
(30, 'Coordinación', 1),
(31, 'CIC', 1),
(32, 'I+D+I', 1),
(33, 'I+D+I', 2),
(34, 'I+D+I', 3);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `encuesta_satisfaccion`
--

CREATE TABLE `encuesta_satisfaccion` (
  `IdUsuario` int(11) NOT NULL,
  `Token` varchar(255) NOT NULL,
  `FechaExpiracion` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `reset_password`
--

CREATE TABLE `reset_password` (
  `IdUsuario` int(11) NOT NULL,
  `Token` varchar(250) NOT NULL,
  `FechaExpiracion` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `solicitudes`
--

CREATE TABLE `solicitudes` (
  `FolioSolicitud` int(11) NOT NULL,
  `IdUsuario` int(11) NOT NULL,
  `Fecha` varchar(50) NOT NULL,
  `Hora` varchar(50) NOT NULL,
  `Telefono` varchar(11) NOT NULL,
  `IdEdificio` int(11) NOT NULL,
  `UbicacionFisica` varchar(20) NOT NULL,
  `Equipo` varchar(30) NOT NULL,
  `Descripcion` text NOT NULL,
  `Estado` enum('Abierto','Asignada','Proceso','Espera','Cerrado') NOT NULL,
  `IdAsignacion` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `solicitudes`
--

INSERT INTO `solicitudes` (`FolioSolicitud`, `IdUsuario`, `Fecha`, `Hora`, `Telefono`, `IdEdificio`, `UbicacionFisica`, `Equipo`, `Descripcion`, `Estado`, `IdAsignacion`) VALUES
(1, 1, '2024-05-17 19:23:15.934', '7:23:15 p.m.', '1234567890', 1, 'Ubicación', 'Equipo', 'dfsfdfs', '', 1),
(2, 1, '2024-05-17 20:08:47.930', '8:08:47 p.m.', '1234567890', 1, 'Ubicación', 'Equipo', 'dcsfddfsd', '', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `solicitudes_log`
--

CREATE TABLE `solicitudes_log` (
  `IdCambio` int(11) NOT NULL,
  `FolioSolicitud` int(11) NOT NULL,
  `IdUsuario` int(11) NOT NULL,
  `Fecha` varchar(50) NOT NULL,
  `Hora` varchar(30) NOT NULL,
  `NuevoEstado` enum('Abierto','Pendiente','Cerrado') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tecnicos`
--

CREATE TABLE `tecnicos` (
  `IdTecnico` int(11) NOT NULL,
  `IdUsuario` int(11) NOT NULL,
  `Nombre` varchar(150) NOT NULL,
  `Apellidos` varchar(150) NOT NULL,
  `NoTrabajador` varchar(100) NOT NULL,
  `Correo` varchar(100) NOT NULL,
  `Telefono` varchar(15) NOT NULL,
  `FechaRegistro` varchar(20) NOT NULL,
  `Estado` enum('Activo','Inactivo') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE `usuarios` (
  `IdUsuario` int(11) NOT NULL,
  `NombreUsuario` varchar(50) NOT NULL,
  `Nombre` varchar(80) NOT NULL,
  `Contrasena` varchar(255) NOT NULL,
  `Rol` enum('Admin','Usuario','Tecnico') NOT NULL,
  `Genero` char(1) NOT NULL,
  `Correo` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`IdUsuario`, `NombreUsuario`, `Nombre`, `Contrasena`, `Rol`, `Genero`, `Correo`) VALUES
(1, 'Administrador', 'Administrador ', '$2a$08$YAoT2WKHOdDX/0hY/AdZguvJnzczW0UNk8UpktC5UljTDTTA.Kcpi', 'Admin', 'M', 'admin@uacam.mx'),
(2, 'UsuarioTest', 'Usuario de prueba', '$2a$08$dPxeFhEG2eMUF4G3OJvnQOBaMexQXALDxb4.fm9ppmOVc.YSxh1jC', 'Usuario', 'M', 'usuario@uacam.mx'),
(3, 'Abraham0', 'Abraham Barrientos', '$2a$08$Gre3OqrtWamFqAjhE4BuHOcUzpNbXWk.GVpZv7IWvetGpreEnqCY.', 'Usuario', 'M', 'aibarrie@uacam.mx'),
(4, 'abrilazar', 'Abril Azar Oreza', '$2a$08$kRLwPWYqUEGiCNdDMYbUt.yoYtJTBuLlG4f5/1CdN.oRfMd8zylBC', 'Usuario', 'F', 'abraazar@uacam.mx'),
(5, 'AdrianEnrique', 'Adrian Enrique Pacheco Zapata', '$2a$08$SOOTWw56tWZjuJA9hVJacedhcxPLIjW4rwiCdB4xE84hEZ9lfoe2G', 'Usuario', 'M', 'aepachez@uacam.mx'),
(6, 'AgapitoLeyva', 'Agapito Leyva Chiw', '$2a$08$4KqVsGbZX9gLvdnlpuwyVuT6M2fK7w.C8NCy0GqdNuMv8unq7rGSa', 'Usuario', 'M', 'agaleyva@uacam.mx'),
(7, 'AlbertoSanchez', 'Alberto Sanchez Espinoza', '$2a$08$pf/3BktkRyEn9Lmdzsu56erS4gFf/RMkNtQoqsTZOeQiY.gy28QBm', 'Usuario', 'M', 'jasances@uacam.mx'),
(8, 'AlejandraCastro', 'Alejandra Castro', '$2a$08$8hPGS1rbQFhUIpQDbjrn0encLIm5FUUfkdPal6ySFNNW/tEumCB82', 'Usuario', 'F', 'accastro@uacam.mx'),
(9, 'AlvaroManuel', 'Alvaro Manuel Cevallos Franco', '$2a$08$1WHwErW9VEX2z6rTHdbvT.30qRWMgkZpm7GEgge0Q624CKbu5Yk1u', 'Usuario', 'M', 'amcebalf@uacam.mx'),
(10, 'AnaLuisa', ' Ana Luisa May Tec', '$2a$08$oP05HLHertogG0qPagpzie3Wva9UNHXAlPZwYNR4Xh2bUCq38JxQW', 'Usuario', 'F', 'usuario@uacam.mx'),
(11, 'AngelicaYuridia', 'Angelica Yuridia Gomez', '$2a$08$qH8Bn8ycYme3k2ACKr30JuFmX0.ZVJoxyupdtfG3j8Y.go.8eW4nu', 'Usuario', 'F', 'anygomez@uacam.mx'),
(12, 'BeatrizVega', 'Beatriz Vega Serratos', '$2a$08$kogx4PxA/5JvCbm3uhrMDORFjHItDXjO1rmo2tN6DMbbU1ahwoeTy', 'Usuario', 'F', 'beaevega@uacam.mx'),
(13, 'CarlosAmador', 'Carlos Amador Cuc Manrero', '$2a$08$BZLmmWy083b6Q0NIZqfDneSSTcFqNuCYDNhBdv.Yclyw3cMog1Amy', 'Usuario', 'M', 'carlacuc@uacam.mx'),
(14, 'CarlosMario', 'Carlos Mario Sosa Silva', '$2a$08$JfH8vmD3mtJoHZ7m1L9z9eBniV2K5HmkR4AZQ3CSce4tI1Yumy4dS', 'Usuario', 'M', 'carmsosa@uacam.mx'),
(15, 'CarlosRodriguez', 'Carlos Rodriguez', '$2a$08$3XtHJ6f.sz/DODK9L/3IneO.G21TR9CFdu5DWtPpeoiPaUWn0G9Uq', 'Usuario', 'M', 'cfrodrig@uacam.mx'),
(16, 'CarlosUc', 'Carlos Uc Rios', '$2a$08$x0BaJOmYGwlX2B7.F1xYzO6r6cLHrlt7EwskVTUwNWvfP1ccTvS5m', 'Usuario', 'M', 'carloeuc@uacam.mx'),
(17, 'DeniceGonzalez', 'Denice Gonzalez', '$2a$08$7kw0IaRPLTK7t.7UCZvS9.Be36at9CGUzvVy/S/tlTakCtYDvgIQW', 'Usuario', 'F', 'digonzal@uacam.mx'),
(18, 'DianaMex', 'Diana Mex Alvarez', '$2a$08$kNiKMCOzschX/.gnDbyPBOaYbK/KGNK/1iSVJanCIs1dMGWOSXNzC', 'Usuario', 'F', 'diancmex@uacam.mx'),
(19, 'DomingoDzul', 'Domingo Dzul González', '$2a$08$VhesCqUGl/XlOteBWYxkf.UNsaWmcXCDmQDKnHQi0NQgvgQD.c6.6', 'Usuario', 'M', 'domadzul@uacam.mx'),
(20, 'EdgarRene', 'Edgar Rene Chan Tun', '$2a$08$Uzlkb23jjqMHcZCPC5UkHOT7WFXo2g4XUucywiLDaXa7Pxe4w9R0W', 'Usuario', 'M', 'edgrchan@uacam.mx'),
(21, 'EmanuelCenturion', 'Emanuel Centurion', '$2a$08$iqDXjpctb2Jqf9XnJ3Zjxu071RNw4hjP04qPTOE.YtmPNs7vCxcim', 'Usuario', 'M', 'eacentur@uacam.mx'),
(22, 'EnriquePerera', 'Enrique Perera', '$2a$08$yqn9En1Mh1oo9eBAgijk6.WO8ljyYbQCXP4xCd2xd1RF8nv/1.oPm', 'Usuario', 'M', 'enperera@uacam.mx'),
(23, 'FelipeNoh', 'Felipe Noh Pat', '$2a$08$A3RMrsDtK/GQA6gWQLhmbeontsOKI5tW211jLZy2OAd0rdfozSftK', 'Usuario', 'M', 'felipnoh@uacam.mx'),
(24, 'FelipeUribe', 'Felipe Uribe', '$2a$08$yyecSk7W//H4Lz4kq.kX4e0JwDJs0WLBqed03we5uFWt9UZceKVve', 'Usuario', 'M', 'hefuribe@uacam.mx'),
(25, 'FidelCarlos', 'Fidel Carlos Rodriguez', '$2a$08$9656iRblLqogDb0GX...x.7LCdE1ns0zhEDGId.eET5WB7r4G2ye.', 'Usuario', 'M', 'ficarlos@uacam.mx'),
(26, 'Franciscobarrera', 'Francisco barrera Lao', '$2a$08$6wfSmAw0k2hBK5TSdBx7Pe7iqsH.DJGN3UKh4C6XQOAFEFxgYFtnu', 'Usuario', 'M', 'fjbarrer@uacam.mx'),
(27, 'FranciscoLezama', 'Francisco Lezama', '$2a$08$hy4Ovw4tjXR9tkK/TWqsw.6o915ZsiSbUoJ/NLkp5JQ4F3JGx0T6a', 'Usuario', 'M', 'frlezama@uacam.mx'),
(28, 'GabrielCanto', 'Gabriel Canto', '$2a$08$jWjw6YfBbQ7cXhDe1t9ps.XTpQyvtoyBM5p5/.FJjygJGxnK6jQsi', 'Usuario', 'M', 'gcanto@uacam.mx'),
(29, 'GabrielaAldana', 'Gabriela Aldana Narváez', '$2a$08$xktmksUNAX.WCRjRj/pLIu5DDNNB2ebPhCSMH8UrzkwsMTDNNoGNe', 'Usuario', 'M', 'gpaldana@uacam.mx'),
(30, 'GanPerez', 'Gan Perez Josue Otoniel', '$2a$08$zg05dUhIGcxu/XZWTDFI0uJ8kxN45oHgERPvEcFDtlLz9sd4PoGyO', 'Usuario', 'M', 'josuogan@uacam.mx'),
(31, 'GermanEscalante', 'German Escalante Notario', '$2a$08$2GBfRZL.9KWhaS0qtlXDMudm4IdOnpGErBa047.gJs/WIjFuWVqqi', 'Usuario', 'M', 'gescalan@uacam.mx'),
(32, 'GregorioPosada', 'Gregorio Posada', '$2a$08$hyrH4Akd9taMMQTc49gxfurO4pm3SIg.rj.yc14FnATLW78AnhwUm', 'Usuario', 'M', 'gposadav@uacam.mx'),
(33, 'GustavoDominguez', 'Gustavo Dominguez Rodríguez', '$2a$08$KlEpOtPh3DMR.xPSKgdkc.TlEjB8Ao70GvxzwAkamddyyvkInu8k2', 'Usuario', 'M', 'gdomingu@uacam.mx'),
(34, 'GustavoMarin', 'Gustavo Marin', '$2a$08$jfGUOgeM1LebJx5LIBrzAeciiu/QT1QCKcykAK2yJkzQEl36wxeEG', 'Usuario', 'M', 'gusmarin@uacam.mx'),
(35, 'HectorQuej', 'Hector Quej Cosgaya', '$2a$08$ib9pnTTqKX0cFqy794gGG.M0eyApXwSkHBjxyux3JXjU0hoxa3vja', 'Usuario', 'M', 'hecmquej@uacam.mx'),
(36, 'HugoRodríguez', 'Hugo Rodríguez Lara', '$2a$08$kh7hpHUQs3PUh705wxpuj.ifNtpOInTuYhxvtq10KTBtE9/fOkK8y', 'Usuario', 'M', 'hrodrigu@uacam.mx'),
(37, 'JaimeAlvarado', 'Jaime Alvarado', '$2a$08$oOAgMVAdy2KOfg1m38WVcOv/BJ3vuWkJd1JX8BPkn5QthzLGL1K3G', 'Usuario', 'M', 'jalvarald@uacam.mx'),
(38, 'JennySanchez', 'Jenny Sanchez Argaez', '$2a$08$rBrjMi2/xVVLKeG1bAObCenOIJv5uyaDRLoPdz1U4.42nlYIMnGci', 'Usuario', 'F', 'jbsanche@uacam.mx'),
(39, 'JesusHipolito', 'Jesus Hipolito Contreras Montejo', '$2a$08$bsH737uO09dEtwDm0r6RoeF1oC9UfjtJ7qYdMzX7GqP/4r935skKy', 'Usuario', 'M', 'jhcontre@uacam.mx'),
(40, 'JoelFlores', 'Joel Flores Escalante', '$2a$08$VfSAlqYUpkidDe8EcWV5xe9ypsqEK7eFzmrgjZANpU5x6KjYyJ8PG', 'Usuario', 'M', 'jcflores@uacam.mx'),
(41, 'JorgeBerzunza', 'Jorge Berzunza Valladares', '$2a$08$hX0t8urg5fEPc5hDGq2N7eSa41kIPT6nVvgLj7vPI0mvYbarSolYW', 'Usuario', 'M', 'jaberzun@uacam.mx'),
(42, 'JorgeChan', 'Jorge Chan González', '$2a$08$vlFCroOO6vop52PAb.DN4.WRqa5xpSdRF/yySSYsxNHJOzV9cGfne', 'Usuario', 'M', 'jorjchan@uacam.mx'),
(43, 'JorgeGonzalez', 'Jorge Gonzalez', '$2a$08$bgyUWIlv8bZP23Qk3mVKS.jLYtlK4Xw0HC1dFxAWVVnwSEueqjyfm', 'Usuario', 'M', 'jagonzal@uacam.mx'),
(44, 'JorgeIvan', 'Jorge Ivan Huicab Santos', '$2a$08$bqaefBAQtLE9Je3ADELmbOXIDvzZqVK8.0EvWW8AJVdRfrulBjt4G', 'Usuario', 'M', 'jihuicab@uacam.mx'),
(45, 'JorgePino', 'Jorge Pino Ocampo', '$2a$08$gtB4TlhrofpokzuoYnSyWe7QuCv4uOkmD.bxA8gHO2DvVrlGuFc62', 'Usuario', 'M', 'josapino@uacam.mx'),
(46, 'JorgeVargas', 'Jorge Vargas Martinez', '$2a$08$uSJcTKUGumgdvP/Ous/pVeXeimlVTZBmsgjB8w6lWvdWghhox4LxO', 'Usuario', 'M', 'jevargam@uacam.mx'),
(47, 'JoseAngel', 'Jose Angel Garcia Reyes', '$2a$08$yzuQyzx3R5nKBV71IYzn/.qB0VpxAILkZ/B37Jqd.or.2HAPG2N6S', 'Usuario', 'M', 'jagarcia@uacam.mx'),
(48, 'JoseAntonio', 'Jose Antonio Flores Gallegos', '$2a$08$mpOYnky7naaN7Avvfqs3.ejDqiBzMcxo8sdYHgnN0e0FZAMLma3Di', 'Usuario', 'M', 'jaflores@uacam.mx'),
(49, 'JoseCarlos', 'Jose Carlos Aguilar Canepa', '$2a$08$adMZ.eLQnQmcosofBe8WTOWfhFWkBgOMh7RkYEYlEPsVCrlBRU5FG', 'Usuario', 'M', 'jcaguilc@uacam.mx'),
(50, 'JoseChavez', 'Jose Chavez Molina', '$2a$08$.IhoNHztsIphxATaGVtMe.WkVyIyq4DIAsLt3KW97df1CEI1iXhSG', 'Usuario', 'M', 'jmchavez@uacam.mx'),
(51, 'JuanCarlos', 'Juan Carlos Ovando', '$2a$08$mDlE1FUheGAQfhFbj1yKf.aGAeD6jJToPUesjN86ptf65yJkd.GRe', 'Usuario', 'M', 'jcovando@uacam.mx'),
(52, 'JuanMoncada', 'Juan Moncada Bolón', '$2a$08$stZMD0Hec0XI00zndvM4juvpdU24lbgcT/Yozszm3BFaG8tVHo54W', 'Usuario', 'M', 'jjmoncad@uacam.mx'),
(53, 'JulioAntonio', 'Julio Antonio Gutérrez González', '$2a$08$C6y35rziQIOpNCSD/RHCi.4bhYyArDgRqXIY/0Q/vlZlj2rx3DoBK', 'Usuario', 'M', 'jagutiea@uacam.mx'),
(54, 'JulioCesar', 'Julio Cesar Martinez Espinoza', '$2a$08$QW6pQmjBkub2tCbplqJWHeLF84twL/9nfDDHFs45asT6zapQN9h5.', 'Usuario', 'M', 'jcmartin@uacam.mx'),
(55, 'JustinoRamirez', 'Justino Ramirez Ortegon', '$2a$08$4MqGB/zTPyCyRQk33M9MauxZcqizwl3uUPGUz4cOJD1qD3aQaSuKC', 'Usuario', 'M', 'jramireo@uacam.mx'),
(56, 'KarenChan', 'Karen Chan Blanco', '$2a$08$9uGuy0WiejsiT1gPPHcryuPl0Y1bZ8x4vBMeBkFK8n8FCzUPnuS7S', 'Usuario', 'F', 'karschan@uacam.mx'),
(57, 'KeniaConde', 'Kenia Conde Medina', '$2a$08$3VFAc5V1znNZ/zCIDmyiJ.RR3MpxUbszWbZ5Y5TA1J6GsNARgfT32', 'Usuario', 'F', 'kepconde@uacam.mx'),
(58, 'LuzMaria', 'Luz Maria', '$2a$08$JFu0QVb2XVnhwvs.32FcheRoILQdIlPk5lxMxA6oTu.Xla3stzkjW', 'Usuario', 'F', 'lmhernan@uacam.mx'),
(59, 'Manuelalejandro', 'Manuel alejandro Gonzales Herrera', '$2a$08$H/NvqP1l88U6UE5ccFmmfue7LIu7I/H4/7o3MxiNDkN8.hU56AVU.', 'Usuario', 'M', 'magonzal@uacam.mx'),
(60, 'ManuelEstrada', 'Manuel Estrada Segovia', '$2a$08$Z.pC4iuCL.cq.AgVew6t3e1FUkm00Gm1qyGTWHxSZ3C9YduUfGp76', 'Usuario', 'M', 'gmestrad@uacam.mx'),
(61, 'ManuelRodriguez', 'Manuel Rodriguez Pérez', '$2a$08$jYOQ870LPE72fUdAqC7KqO36Knwk05qF6Ljj4FuiIn48B2hB3qYf2', 'Usuario', 'M', 'mjrodrig@uacam.mx'),
(62, 'MarcoMoreno', 'Marco Moreno Garcia', '$2a$08$lrdrV0ld/g5jOKRK95463OQZrOCLJPcjyA70FM/xekwBDfvYd5SyC', 'Usuario', 'M', 'mamoreng@uacam.mx'),
(63, 'MarcoOropeza', 'Marco Oropeza', '$2a$08$d2qsgWy.EtTa30n6YVcIBerLV5mP.yIx9bQQ1Fw.610QPugkkOVle', 'Usuario', 'M', 'mforopez@uacam.mx'),
(64, 'MargaritaCastillo', 'Margarita Castillo', '$2a$08$uXiwE/j7UoeX1uI44as1iezDBw6yuzK2/Y.ir7hP3NovUA.0Ojlsq', 'Usuario', 'F', 'mcastill@uacam.mx'),
(65, 'MariaJose', 'Maria Jose Ramos Alvarado', '$2a$08$hPHXXhzDRYxAw8fIMPPPWeGUtAuq8klCPW8YG/BevMwphEIRsuj2y', 'Usuario', 'M', 'majramos@uacam.mx'),
(66, 'MarioNicolas', 'Mario Nicolas Heredia', '$2a$08$o4V08V4UjWRbKQo0.I3SUu//ic9PErYnmHx1izp8m8Glc7r2fS.ea', 'Usuario', 'M', 'mnheredi@uacam.mx'),
(67, 'MauricioHuchin', 'Mauricio Huchin', '$2a$08$ZDPAZgkbR8DPs6hjnDq.CuzKVIapyx21xbQ6EyeJ62cLtFGsEConO', 'Usuario', 'M', 'mihuchim@uacam.mx'),
(68, 'MauricioQuen', 'Mauricio Quen', '$2a$08$WBSDMwPBg.zCLsH7rTfg5eQSPZSP9upxig37Ktrl31D/2C.DoBwFm', 'Usuario', 'M', 'maurquen@uacam.mx'),
(69, 'MelissaPavon', 'Melissa Pavon', '$2a$08$8aqPW8wGKbXV5padn5eKZ.Qt4J01mSzvGp/2IOqqMIOXHm3Otmjgi', 'Usuario', 'F', 'mraguila@uacam.mx'),
(70, 'MengYenShih', 'Meng Yen Shih', '$2a$08$n0NzbMfKOww4Z9cA6fGt.e/bWd87v4eExT4NL3izZSzOalLK7vbl2', 'Usuario', 'M', 'smengyen@uacam.mx'),
(71, 'NancyCuevas', 'Nancy Cuevas', '$2a$08$WJmQVJmYmSqp/GOCCIW2TupSPmMyT8rEj7F/dm0GDdVdHhhDKA2.O', 'Usuario', 'F', 'nagortiz@uacam.mx'),
(72, 'NicomedesMedina', 'Nicomedes Medina Perez', '$2a$08$hYiijs6Ncilwtj3TGF3m9egiNSNUCeO/PCgCjbI0F72QHU.9ojqgG', 'Usuario', 'M', 'nicperez@uacam.mx'),
(73, 'NoeAlberto', 'Noe Alberto Chi Montalvo', '$2a$08$zYxq33/GnrGpIKJZ15S6K.JGqthmWxARJmwt2t429EleBKmSOXrR.', 'Usuario', 'M', 'namontal@uacam.mx'),
(74, 'OfeliaTun', 'Ofelia Tun Díaz', '$2a$08$w9Cjd0mbZfPRcUrxr/53VeF/XXwmSK8eMCH0lFdEjA6CIL3EaO6NC', 'Usuario', 'F', 'ofelatun@uacam.mx'),
(75, 'OscarMay', 'Oscar May', '$2a$08$Qge2CQS.TbUJEmGjg65qGu0XMGl0/j1nZf1qDG7rg5rJ1/Due4jq2', 'Usuario', 'M', 'oscajmay@uacam.mx'),
(76, 'Ramondel', 'Ramon del Jesus Pali', '$2a$08$HE8yTEzZ7J4GugC3AGzkReJ61FDR5.ciZgbA3r6/In7ZLHpQuKACG', 'Usuario', 'M', 'ramjpali@uacam.mx'),
(77, 'RicardoSalazar', 'Ricardo Salazar Uitz', '$2a$08$2M7nwDNrCGu.IDYkZ2ww/.so1f6hu68S8SpCBzeIvhQhnozNKwLCG', 'Usuario', 'M', 'rrsalaza@uacam.mx'),
(78, 'RicardoSanchez', 'Ricardo Sanchez', '$2a$08$8ecaVFm5SwMWPilrr55fme6gMhSstypzpyZr8a2VWPmbas9BlDCE2', 'Usuario', 'M', 'rjsanche@uacam.mx'),
(79, 'RobertoCarlos', 'Roberto Carlos Canto', '$2a$08$zF6n76rjEkg38hY6UJSI8uZXU4k6vu4czQH7A4pQPIgo5X/QJ2GqC', 'Usuario', 'M', 'roccanto@uacam.mx'),
(80, 'RomanTurriza', 'Roman Turriza Canul', '$2a$08$wZmnjjv.L3TRJUDApQDbceZpC/3biOzKvx58aYaW80TIzEd1p/kzK', 'Usuario', 'M', 'roacanul@uacam.mx'),
(81, 'RoseliaTurriza', 'Roselia Turriza Mena', '$2a$08$5AsMVFOQss0Zkcstt6VWDOFfRqzuxeG3dwpWpJpRq9kR/dKeuom0W', 'Usuario', 'F', 'rlturriz@uacam.mx'),
(82, 'ValladaresCastellanos', 'Valladares Castellanos Alejandro', '$2a$08$AgGnQXnY.R3.czgVYa3OVOuTUONVfF..VWfG5iIj1K1wbAJrCayPm', 'Usuario', 'M', 'mavallad@uacam.mx'),
(83, 'VictorCastillo', 'Victor Castillo', '$2a$08$NzFGcyeL7OcKa84R57ROQuWaZJmypFdK4do1s/NtAG0x9nENYxTye', 'Usuario', 'M', 'vacastil@uacam.mx'),
(84, 'VictorLanz', 'Victor Lanz', '$2a$08$/IuiZfwBMVXTeTXHof8/tOojRy8StOoc.lxaDVWcVdCaJfoloArNS', 'Usuario', 'M', 'vicmlanz@uacam.mx'),
(85, 'VictorMoo', 'Victor Moo Yam', '$2a$08$lWeMZZvIjp9gTusiygYa3.i9.kuYdSvhBlNrXwOwNdvhl4JmJNL1G', 'Usuario', 'M', 'victmmoo@uacam.mx'),
(86, 'JulioGarcia', 'Julio Garcia Fajardo', '$2a$08$yzcCDI6fGajOgkFGIm0nEevhsOUqdwtEN5MWtbYjrkWGAj4r0UGyS', 'Usuario', 'M', 'jcgarcif@uacam.mx'),
(87, 'JuanChuc', 'Juan Chuc Mendez', '$2a$08$n.l5SmmxJvL0p/GLD4XcTuCp4.6pEF.BynU/.SJR9Z9HTk1cz6hPC', 'Usuario', 'M', 'juaachuc@uacam.mx'),
(88, 'ScarMovil', 'Scarlet Movil', '$2a$08$wVLl1zW1TvZxCvqtx6jQiei8SxIfNrPMFmoSU/yvhI8TDWVNiUz2.', 'Usuario', 'F', 'al057517@uacam.mx'),
(89, 'CesarMovil', 'Cesar Gonzalez', '$2a$08$ILyOc.kOxy66GGCz3Jp7NunRh5he/.5L113/Eyc1oRdOLnKyjbZTK', 'Usuario', 'M', 'al052899@uacam.mx'),
(90, 'PruebaMovil', 'Aver', '$2a$08$8SrnP/Rgb1oquQjHzo6IHOvzxmZjDrLWWakIu7f5p8D8NkvF90kPS', 'Usuario', 'F', 'al057517@uacam.mx');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `vales`
--

CREATE TABLE `vales` (
  `idVale` int(11) NOT NULL,
  `FolioSolicitud` int(11) NOT NULL,
  `Equipo` varchar(50) NOT NULL,
  `NoSerieEquipo` varchar(60) NOT NULL,
  `MarcaEquipo` varchar(50) NOT NULL,
  `ModeloEquipo` varchar(50) NOT NULL,
  `Caracteristicas` varchar(255) NOT NULL,
  `Estado` enum('Funciona','No Funciona','Esperar') NOT NULL,
  `NombreUsuario` varchar(60) NOT NULL,
  `Fecha` varchar(50) NOT NULL,
  `Estatus` enum('Disponible','No disponible') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `asignaciones`
--
ALTER TABLE `asignaciones`
  ADD PRIMARY KEY (`IdAsignacion`),
  ADD KEY `IdSolicitud` (`IdSolicitud`),
  ADD KEY `IdTecnico` (`IdTecnico`);

--
-- Indices de la tabla `dictamenes`
--
ALTER TABLE `dictamenes`
  ADD PRIMARY KEY (`idDictamen`),
  ADD UNIQUE KEY `unique_dictamen_vale` (`idVale`),
  ADD KEY `FolioSolicitud` (`FolioSolicitud`);

--
-- Indices de la tabla `edificios`
--
ALTER TABLE `edificios`
  ADD PRIMARY KEY (`IdEdificio`);

--
-- Indices de la tabla `solicitudes`
--
ALTER TABLE `solicitudes`
  ADD PRIMARY KEY (`FolioSolicitud`),
  ADD KEY `IdUsuario` (`IdUsuario`),
  ADD KEY `IdEdificio` (`IdEdificio`),
  ADD KEY `IdAsignacion` (`IdAsignacion`);

--
-- Indices de la tabla `solicitudes_log`
--
ALTER TABLE `solicitudes_log`
  ADD PRIMARY KEY (`IdCambio`),
  ADD KEY `IdUsuario` (`IdUsuario`),
  ADD KEY `FolioSolicitud` (`FolioSolicitud`);

--
-- Indices de la tabla `tecnicos`
--
ALTER TABLE `tecnicos`
  ADD PRIMARY KEY (`IdTecnico`),
  ADD KEY `IdUsuario` (`IdUsuario`);

--
-- Indices de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`IdUsuario`),
  ADD UNIQUE KEY `NombreUsuario` (`NombreUsuario`),
  ADD UNIQUE KEY `NombreUsuario_2` (`NombreUsuario`);

--
-- Indices de la tabla `vales`
--
ALTER TABLE `vales`
  ADD PRIMARY KEY (`idVale`),
  ADD KEY `FolioSolicitud` (`FolioSolicitud`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `asignaciones`
--
ALTER TABLE `asignaciones`
  MODIFY `IdAsignacion` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT de la tabla `dictamenes`
--
ALTER TABLE `dictamenes`
  MODIFY `idDictamen` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `edificios`
--
ALTER TABLE `edificios`
  MODIFY `IdEdificio` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=35;

--
-- AUTO_INCREMENT de la tabla `solicitudes`
--
ALTER TABLE `solicitudes`
  MODIFY `FolioSolicitud` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `solicitudes_log`
--
ALTER TABLE `solicitudes_log`
  MODIFY `IdCambio` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `tecnicos`
--
ALTER TABLE `tecnicos`
  MODIFY `IdTecnico` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `IdUsuario` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=91;

--
-- AUTO_INCREMENT de la tabla `vales`
--
ALTER TABLE `vales`
  MODIFY `idVale` int(11) NOT NULL AUTO_INCREMENT;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `asignaciones`
--
ALTER TABLE `asignaciones`
  ADD CONSTRAINT `asignaciones_ibfk_1` FOREIGN KEY (`IdSolicitud`) REFERENCES `solicitudes` (`FolioSolicitud`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `asignaciones_ibfk_2` FOREIGN KEY (`IdTecnico`) REFERENCES `tecnicos` (`IdTecnico`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `dictamenes`
--
ALTER TABLE `dictamenes`
  ADD CONSTRAINT `dictamenes_ibfk_1` FOREIGN KEY (`FolioSolicitud`) REFERENCES `solicitudes` (`FolioSolicitud`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `dictamenes_ibfk_2` FOREIGN KEY (`idVale`) REFERENCES `vales` (`idVale`);

--
-- Filtros para la tabla `solicitudes`
--
ALTER TABLE `solicitudes`
  ADD CONSTRAINT `solicitudes_ibfk_1` FOREIGN KEY (`IdUsuario`) REFERENCES `usuarios` (`IdUsuario`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `solicitudes_ibfk_2` FOREIGN KEY (`IdEdificio`) REFERENCES `edificios` (`IdEdificio`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `solicitudes_log`
--
ALTER TABLE `solicitudes_log`
  ADD CONSTRAINT `solicitudes_log_ibfk_1` FOREIGN KEY (`IdUsuario`) REFERENCES `usuarios` (`IdUsuario`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `solicitudes_log_ibfk_2` FOREIGN KEY (`FolioSolicitud`) REFERENCES `solicitudes` (`FolioSolicitud`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `tecnicos`
--
ALTER TABLE `tecnicos`
  ADD CONSTRAINT `tecnicos_ibfk_1` FOREIGN KEY (`IdUsuario`) REFERENCES `usuarios` (`IdUsuario`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `vales`
--
ALTER TABLE `vales`
  ADD CONSTRAINT `vales_ibfk_1` FOREIGN KEY (`FolioSolicitud`) REFERENCES `solicitudes` (`FolioSolicitud`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
