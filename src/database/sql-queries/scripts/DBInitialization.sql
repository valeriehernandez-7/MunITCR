USE [MunITCR]
GO
/****** Object:  Table [dbo].[CCArregloPago] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CCArregloPago](
	[IDCC] [int] NOT NULL,
 CONSTRAINT [PK_CCArregloPago] PRIMARY KEY CLUSTERED 
(
	[IDCC] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CCBasura] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CCBasura](
	[IDCC] [int] NOT NULL,
	[MontoFijo] [money] NOT NULL,
	[MontoMinimo] [money] NOT NULL,
	[MontoMinimoM2] [money] NOT NULL,
	[MontoTractoM2] [money] NOT NULL,
 CONSTRAINT [PK_CCBasura] PRIMARY KEY CLUSTERED 
(
	[IDCC] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CCConsumoAgua] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CCConsumoAgua](
	[IDCC] [int] NOT NULL,
	[MinimoM3] [int] NOT NULL,
	[MontoMinimo] [money] NOT NULL,
	[MontoMinimoM3] [money] NOT NULL,
 CONSTRAINT [PK_CCAgua] PRIMARY KEY CLUSTERED 
(
	[IDCC] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CCImpuestoPropiedad] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CCImpuestoPropiedad](
	[IDCC] [int] NOT NULL,
	[MontoPorcentual] [float] NOT NULL,
 CONSTRAINT [PK_CCPropiedad] PRIMARY KEY CLUSTERED 
(
	[IDCC] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CCInteresMoratorio] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CCInteresMoratorio](
	[IDCC] [int] NOT NULL,
	[MontoPorcentual] [float] NOT NULL,
 CONSTRAINT [PK_CCInteresMoratorio] PRIMARY KEY CLUSTERED 
(
	[IDCC] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CCMantenimientoParque] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CCMantenimientoParque](
	[IDCC] [int] NOT NULL,
	[MontoFijo] [money] NOT NULL,
 CONSTRAINT [PK_CCMantenimientoParque] PRIMARY KEY CLUSTERED 
(
	[IDCC] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CCPatenteComercial] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CCPatenteComercial](
	[IDCC] [int] NOT NULL,
	[MontoFijo] [money] NOT NULL,
 CONSTRAINT [PK_CCPatenteComercial] PRIMARY KEY CLUSTERED 
(
	[IDCC] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CCReconexion] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CCReconexion](
	[IDCC] [int] NOT NULL,
	[MontoFijo] [money] NOT NULL,
 CONSTRAINT [PK_CCReconexion] PRIMARY KEY CLUSTERED 
(
	[IDCC] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ComprobantePago] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ComprobantePago](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[IDMedioPago] [int] NOT NULL,
	[Fecha] [date] NOT NULL,
	[Referencia] [bigint] NOT NULL,
 CONSTRAINT [PK_ComprobantePago] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ConceptoCobro] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ConceptoCobro](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[IDPeriodoCC] [int] NOT NULL,
	[IDTipoMontoCC] [int] NOT NULL,
	[Nombre] [varchar](128) NOT NULL,
 CONSTRAINT [PK_ConceptoCobro] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DetalleCC] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DetalleCC](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[IDFactura] [int] NOT NULL,
	[IDPropiedadXConceptoCobro] [int] NOT NULL,
	[Monto] [money] NOT NULL,
	[Activo] [bit] NOT NULL,
 CONSTRAINT [PK_DetalleCC] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DetalleCCArregloPago] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DetalleCCArregloPago](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[IDDetalleCC] [int] NOT NULL,
	[IDMovimientoArregloPago] [int] NOT NULL,
 CONSTRAINT [PK_DetalleCCArregloPago_1] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DetalleCCConsumoAgua] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DetalleCCConsumoAgua](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[IDDetalleCC] [int] NOT NULL,
	[IDMovimientoConsumoAgua] [int] NOT NULL,
 CONSTRAINT [PK_DetalleCCConsumoAgua_1] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EntityType] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EntityType](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_EntityType] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ErrorLog] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ErrorLog](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Username] [nvarchar](128) NULL,
	[ErrorNumber] [int] NULL,
	[ErrorState] [int] NULL,
	[ErrorSeverity] [int] NULL,
	[ErrorLine] [int] NULL,
	[ErrorProcedure] [nvarchar](128) NULL,
	[ErrorMessage] [nvarchar](max) NULL,
	[ErrorDateTime] [datetime] NULL,
 CONSTRAINT [PK_ErrorLog] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EventLog] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EventLog](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[IDEventType] [int] NOT NULL,
	[IDEntityType] [int] NOT NULL,
	[EntityID] [int] NOT NULL,
	[BeforeUpdate] [nvarchar](max) NULL,
	[AfterUpdate] [nvarchar](max) NULL,
	[Username] [varchar](16) NOT NULL,
	[UserIP] [varchar](64) NOT NULL,
	[DateTime] [datetime] NOT NULL,
 CONSTRAINT [PK_EventLog] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EventType] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EventType](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](8) NOT NULL,
 CONSTRAINT [PK_EventType] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Factura] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Factura](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[IDPropiedad] [int] NOT NULL,
	[IDComprobantePago] [int] NULL,
	[Fecha] [date] NOT NULL,
	[FechaVencimiento] [date] NOT NULL,
	[MontoOriginal] [money] NOT NULL,
	[MontoPagar] [money] NOT NULL,
	[PlanArregloPago] [bit] NOT NULL,
	[Activo] [bit] NOT NULL,
 CONSTRAINT [PK_Factura] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MedioPago] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MedioPago](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Nombre] [varchar](128) NOT NULL,
 CONSTRAINT [PK_TipoMedioPago] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MovimientoArregloPago] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MovimientoArregloPago](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[IDTipoMovimientoArregloPago] [int] NOT NULL,
	[IDPropiedadXCCArregloPago] [int] NOT NULL,
	[Fecha] [date] NOT NULL,
	[MontoCuota] [money] NOT NULL,
	[MontoAmortizacion] [money] NOT NULL,
	[MontoInteres] [money] NOT NULL,
 CONSTRAINT [PK_MovimientoArregloPago] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MovimientoConsumoAgua] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MovimientoConsumoAgua](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[IDTipoMovimientoConsumoAgua] [int] NOT NULL,
	[IDPropiedadXCCConsumoAgua] [int] NOT NULL,
	[Fecha] [date] NOT NULL,
	[MontoM3] [int] NOT NULL,
	[LecturaMedidor] [int] NOT NULL,
 CONSTRAINT [PK_MovimientoConsumoAgua] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OrdenCorte] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrdenCorte](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[IDFactura] [int] NOT NULL,
	[Fecha] [date] NOT NULL,
	[Activo] [bit] NOT NULL,
 CONSTRAINT [PK_OrdenCorte] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OrdenReconexion] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrdenReconexion](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[IDOrdenCorte] [int] NOT NULL,
	[Fecha] [date] NOT NULL,
 CONSTRAINT [PK_OrdenReconexion] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Parametro] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Parametro](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[IDTipoParametro] [int] NOT NULL,
	[Descripcion] [varchar](128) NOT NULL,
 CONSTRAINT [PK_Parametro] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ParametroInteger] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ParametroInteger](
	[IDParametro] [int] NOT NULL,
	[Valor] [int] NOT NULL,
 CONSTRAINT [PK_ParametroEntero] PRIMARY KEY CLUSTERED 
(
	[IDParametro] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PeriodoMontoCC] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PeriodoMontoCC](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Nombre] [varchar](128) NOT NULL,
	[Meses] [int] NOT NULL,
 CONSTRAINT [PK_PeriodoMontoCC] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Persona] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Persona](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[IDTipoDocIdentidad] [int] NOT NULL,
	[Nombre] [varchar](128) NOT NULL,
	[ValorDocIdentidad] [varchar](64) NOT NULL,
	[Telefono1] [varchar](16) NOT NULL,
	[Telefono2] [varchar](16) NOT NULL,
	[CorreoElectronico] [varchar](256) NOT NULL,
	[Activo] [bit] NOT NULL,
 CONSTRAINT [PK_Persona] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PersonaXPropiedad] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PersonaXPropiedad](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[IDPersona] [int] NOT NULL,
	[IDPropiedad] [int] NOT NULL,
	[FechaInicio] [date] NOT NULL,
	[FechaFin] [date] NULL,
	[Activo] [bit] NOT NULL,
 CONSTRAINT [PK_PersonaXPropiedad] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Propiedad] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Propiedad](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[IDTipoUsoPropiedad] [int] NOT NULL,
	[IDTipoZonaPropiedad] [int] NOT NULL,
	[Lote] [varchar](32) NOT NULL,
	[MetrosCuadrados] [bigint] NOT NULL,
	[ValorFiscal] [money] NOT NULL,
	[FechaRegistro] [date] NOT NULL,
	[Activo] [bit] NOT NULL,
 CONSTRAINT [PK_Propiedad] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PropiedadXCCArregloPago] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PropiedadXCCArregloPago](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[IDPropiedadXCC] [int] NOT NULL,
	[IDTasaInteres] [int] NOT NULL,
	[MontoOriginal] [money] NOT NULL,
	[MontoSaldo] [money] NOT NULL,
	[MontoAcumuladoAmortizacion] [money] NOT NULL,
	[MontoAcumuladoAplicado] [money] NOT NULL,
	[Activo] [bit] NOT NULL,
 CONSTRAINT [PK_PropiedadXCCArregloPago] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PropiedadXCCConsumoAgua] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PropiedadXCCConsumoAgua](
	[IDPropiedadXCC] [int] NOT NULL,
	[Medidor] [varchar](16) NOT NULL,
	[LecturaMedidor] [int] NOT NULL,
 CONSTRAINT [PK_PropiedadXCCConsumoAgua] PRIMARY KEY CLUSTERED 
(
	[IDPropiedadXCC] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PropiedadXConceptoCobro] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PropiedadXConceptoCobro](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[IDPropiedad] [int] NOT NULL,
	[IDConceptoCobro] [int] NOT NULL,
	[FechaInicio] [date] NOT NULL,
	[FechaFin] [date] NULL,
 CONSTRAINT [PK_PropiedadXConceptoCobro] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TasaInteres] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TasaInteres](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[PlazoMeses] [int] NOT NULL,
	[TasaInteresAnual] [float] NOT NULL,
 CONSTRAINT [PK_TasaInteres] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TipoDocIdentidad] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TipoDocIdentidad](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Nombre] [varchar](128) NOT NULL,
 CONSTRAINT [PK_TipoDocIdentidad] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TipoMontoCC] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TipoMontoCC](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Nombre] [varchar](128) NOT NULL,
 CONSTRAINT [PK_TipoMontoCC] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TipoMovimientoArregloPago] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TipoMovimientoArregloPago](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Nombre] [varchar](128) NOT NULL,
 CONSTRAINT [PK_TipoMovimientoArregloPago] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TipoMovimientoConsumoAgua] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TipoMovimientoConsumoAgua](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Nombre] [varchar](128) NOT NULL,
 CONSTRAINT [PK_TipoMovimientoConsumoAgua] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TipoParametro] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TipoParametro](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Nombre] [varchar](128) NOT NULL,
 CONSTRAINT [PK_TipoParametro] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TipoUsoPropiedad] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TipoUsoPropiedad](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Nombre] [varchar](128) NOT NULL,
 CONSTRAINT [PK_TipoUsoPropiedad] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TipoZonaPropiedad] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TipoZonaPropiedad](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Nombre] [varchar](128) NOT NULL,
 CONSTRAINT [PK_TipoZonaPropiedad] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Usuario] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Usuario](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[IDPersona] [int] NULL,
	[Username] [varchar](16) NOT NULL,
	[Password] [varchar](16) NOT NULL,
	[Administrador] [bit] NOT NULL,
	[Activo] [bit] NOT NULL,
 CONSTRAINT [PK_Usuario] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UsuarioXPropiedad] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UsuarioXPropiedad](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[IDUsuario] [int] NOT NULL,
	[IDPropiedad] [int] NOT NULL,
	[FechaInicio] [date] NOT NULL,
	[FechaFin] [date] NULL,
	[Activo] [bit] NOT NULL,
 CONSTRAINT [PK_UsuarioXPropiedad] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ComprobantePago] ADD  CONSTRAINT [DF_ComprobantePago_Fecha]  DEFAULT (getdate()) FOR [Fecha]
GO
ALTER TABLE [dbo].[DetalleCC] ADD  CONSTRAINT [DF_DetalleCC_Monto]  DEFAULT ((0)) FOR [Monto]
GO
ALTER TABLE [dbo].[DetalleCC] ADD  CONSTRAINT [DF_DetalleCC_Activo]  DEFAULT ((1)) FOR [Activo]
GO
ALTER TABLE [dbo].[EventLog] ADD  CONSTRAINT [DF_EventLog_Username]  DEFAULT ('MunITCR') FOR [Username]
GO
ALTER TABLE [dbo].[EventLog] ADD  CONSTRAINT [DF_EventLog_UserIP]  DEFAULT ('0.0.0.0') FOR [UserIP]
GO
ALTER TABLE [dbo].[EventLog] ADD  CONSTRAINT [DF_EventLog_DateTime]  DEFAULT (getdate()) FOR [DateTime]
GO
ALTER TABLE [dbo].[Factura] ADD  CONSTRAINT [DF_Factura_IDComprobantePago]  DEFAULT (NULL) FOR [IDComprobantePago]
GO
ALTER TABLE [dbo].[Factura] ADD  CONSTRAINT [DF_Factura_Fecha]  DEFAULT (getdate()) FOR [Fecha]
GO
ALTER TABLE [dbo].[Factura] ADD  CONSTRAINT [DF_Factura_FechaVencimiento]  DEFAULT (getdate()) FOR [FechaVencimiento]
GO
ALTER TABLE [dbo].[Factura] ADD  CONSTRAINT [DF_Factura_MontoOriginal]  DEFAULT ((0)) FOR [MontoOriginal]
GO
ALTER TABLE [dbo].[Factura] ADD  CONSTRAINT [DF_Factura_MontoPagar]  DEFAULT ((0)) FOR [MontoPagar]
GO
ALTER TABLE [dbo].[Factura] ADD  CONSTRAINT [DF_Factura_PlanArregloPago]  DEFAULT ((0)) FOR [PlanArregloPago]
GO
ALTER TABLE [dbo].[Factura] ADD  CONSTRAINT [DF_Factura_Activo]  DEFAULT ((1)) FOR [Activo]
GO
ALTER TABLE [dbo].[MovimientoArregloPago] ADD  CONSTRAINT [DF_MovimientoArregloPago_Fecha]  DEFAULT (getdate()) FOR [Fecha]
GO
ALTER TABLE [dbo].[MovimientoArregloPago] ADD  CONSTRAINT [DF_MovimientoArregloPago_Monto]  DEFAULT ((0)) FOR [MontoCuota]
GO
ALTER TABLE [dbo].[MovimientoArregloPago] ADD  CONSTRAINT [DF_MovimientoArregloPago_Amortizado]  DEFAULT ((0)) FOR [MontoAmortizacion]
GO
ALTER TABLE [dbo].[MovimientoArregloPago] ADD  CONSTRAINT [DF_MovimientoArregloPago_Intereses]  DEFAULT ((0)) FOR [MontoInteres]
GO
ALTER TABLE [dbo].[MovimientoConsumoAgua] ADD  CONSTRAINT [DF_MovimientoConsumoAgua_MontoM3]  DEFAULT ((0)) FOR [MontoM3]
GO
ALTER TABLE [dbo].[MovimientoConsumoAgua] ADD  CONSTRAINT [DF_MovimientoConsumoAgua_LecturaMedidor]  DEFAULT ((0)) FOR [LecturaMedidor]
GO
ALTER TABLE [dbo].[OrdenCorte] ADD  CONSTRAINT [DF_OrdenCorte_Fecha]  DEFAULT (getdate()) FOR [Fecha]
GO
ALTER TABLE [dbo].[OrdenCorte] ADD  CONSTRAINT [DF_OrdenCorte_EstadoPagoCorte]  DEFAULT ((1)) FOR [Activo]
GO
ALTER TABLE [dbo].[OrdenReconexion] ADD  CONSTRAINT [DF_OrdenReconexion_Fecha]  DEFAULT (getdate()) FOR [Fecha]
GO
ALTER TABLE [dbo].[PeriodoMontoCC] ADD  CONSTRAINT [DF_PeriodoMontoCC_Meses]  DEFAULT ((1)) FOR [Meses]
GO
ALTER TABLE [dbo].[Persona] ADD  CONSTRAINT [DF_Persona_Activo]  DEFAULT ((1)) FOR [Activo]
GO
ALTER TABLE [dbo].[PersonaXPropiedad] ADD  CONSTRAINT [DF_PersonaXPropiedad_FechaFin]  DEFAULT (NULL) FOR [FechaFin]
GO
ALTER TABLE [dbo].[PersonaXPropiedad] ADD  CONSTRAINT [DF_PersonaXPropiedad_Activo]  DEFAULT ((1)) FOR [Activo]
GO
ALTER TABLE [dbo].[Propiedad] ADD  CONSTRAINT [DF_Propiedad_MetrosCuadrados]  DEFAULT ((0)) FOR [MetrosCuadrados]
GO
ALTER TABLE [dbo].[Propiedad] ADD  CONSTRAINT [DF_Propiedad_ValorFiscal]  DEFAULT ((0)) FOR [ValorFiscal]
GO
ALTER TABLE [dbo].[Propiedad] ADD  CONSTRAINT [DF_Propiedad_FechaRegistro]  DEFAULT (getdate()) FOR [FechaRegistro]
GO
ALTER TABLE [dbo].[Propiedad] ADD  CONSTRAINT [DF_Propiedad_Activo]  DEFAULT ((1)) FOR [Activo]
GO
ALTER TABLE [dbo].[PropiedadXCCArregloPago] ADD  CONSTRAINT [DF_PropiedadXCCArregloPago_MontoOriginal]  DEFAULT ((0)) FOR [MontoOriginal]
GO
ALTER TABLE [dbo].[PropiedadXCCArregloPago] ADD  CONSTRAINT [DF_PropiedadXCCArregloPago_Saldo]  DEFAULT ((0)) FOR [MontoSaldo]
GO
ALTER TABLE [dbo].[PropiedadXCCArregloPago] ADD  CONSTRAINT [DF_PropiedadXCCArregloPago_AcumuladoAmortizado]  DEFAULT ((0)) FOR [MontoAcumuladoAmortizacion]
GO
ALTER TABLE [dbo].[PropiedadXCCArregloPago] ADD  CONSTRAINT [DF_PropiedadXCCArregloPago_AcumuladoAplicado]  DEFAULT ((0)) FOR [MontoAcumuladoAplicado]
GO
ALTER TABLE [dbo].[PropiedadXCCArregloPago] ADD  CONSTRAINT [DF_PropiedadXCCArregloPago_Activo]  DEFAULT ((1)) FOR [Activo]
GO
ALTER TABLE [dbo].[PropiedadXCCConsumoAgua] ADD  CONSTRAINT [DF_PropiedadXCCConsumoAgua_LecturaMedidor]  DEFAULT ((0)) FOR [LecturaMedidor]
GO
ALTER TABLE [dbo].[PropiedadXConceptoCobro] ADD  CONSTRAINT [DF_Table_1_]  DEFAULT (NULL) FOR [FechaFin]
GO
ALTER TABLE [dbo].[Usuario] ADD  CONSTRAINT [DF_Usuario_Administrador]  DEFAULT ((0)) FOR [Administrador]
GO
ALTER TABLE [dbo].[Usuario] ADD  CONSTRAINT [DF_Usuario_Activo]  DEFAULT ((1)) FOR [Activo]
GO
ALTER TABLE [dbo].[UsuarioXPropiedad] ADD  CONSTRAINT [DF_UsuarioXPropiedad_Activo]  DEFAULT ((1)) FOR [Activo]
GO
ALTER TABLE [dbo].[CCArregloPago]  WITH CHECK ADD  CONSTRAINT [FK_CCArregloPago_ConceptoCobro] FOREIGN KEY([IDCC])
REFERENCES [dbo].[ConceptoCobro] ([ID])
GO
ALTER TABLE [dbo].[CCArregloPago] CHECK CONSTRAINT [FK_CCArregloPago_ConceptoCobro]
GO
ALTER TABLE [dbo].[CCBasura]  WITH CHECK ADD  CONSTRAINT [FK_CCBasura_ConceptoCobro] FOREIGN KEY([IDCC])
REFERENCES [dbo].[ConceptoCobro] ([ID])
GO
ALTER TABLE [dbo].[CCBasura] CHECK CONSTRAINT [FK_CCBasura_ConceptoCobro]
GO
ALTER TABLE [dbo].[CCConsumoAgua]  WITH CHECK ADD  CONSTRAINT [FK_CCConsumoAgua_ConceptoCobro] FOREIGN KEY([IDCC])
REFERENCES [dbo].[ConceptoCobro] ([ID])
GO
ALTER TABLE [dbo].[CCConsumoAgua] CHECK CONSTRAINT [FK_CCConsumoAgua_ConceptoCobro]
GO
ALTER TABLE [dbo].[CCImpuestoPropiedad]  WITH CHECK ADD  CONSTRAINT [FK_CCImpuestoPropiedad_ConceptoCobro] FOREIGN KEY([IDCC])
REFERENCES [dbo].[ConceptoCobro] ([ID])
GO
ALTER TABLE [dbo].[CCImpuestoPropiedad] CHECK CONSTRAINT [FK_CCImpuestoPropiedad_ConceptoCobro]
GO
ALTER TABLE [dbo].[CCInteresMoratorio]  WITH CHECK ADD  CONSTRAINT [FK_CCInteresMoratorio_ConceptoCobro] FOREIGN KEY([IDCC])
REFERENCES [dbo].[ConceptoCobro] ([ID])
GO
ALTER TABLE [dbo].[CCInteresMoratorio] CHECK CONSTRAINT [FK_CCInteresMoratorio_ConceptoCobro]
GO
ALTER TABLE [dbo].[CCMantenimientoParque]  WITH CHECK ADD  CONSTRAINT [FK_CCMantenimientoParque_ConceptoCobro] FOREIGN KEY([IDCC])
REFERENCES [dbo].[ConceptoCobro] ([ID])
GO
ALTER TABLE [dbo].[CCMantenimientoParque] CHECK CONSTRAINT [FK_CCMantenimientoParque_ConceptoCobro]
GO
ALTER TABLE [dbo].[CCPatenteComercial]  WITH CHECK ADD  CONSTRAINT [FK_CCPatenteComercial_ConceptoCobro] FOREIGN KEY([IDCC])
REFERENCES [dbo].[ConceptoCobro] ([ID])
GO
ALTER TABLE [dbo].[CCPatenteComercial] CHECK CONSTRAINT [FK_CCPatenteComercial_ConceptoCobro]
GO
ALTER TABLE [dbo].[CCReconexion]  WITH CHECK ADD  CONSTRAINT [FK_CCReconexion_ConceptoCobro] FOREIGN KEY([IDCC])
REFERENCES [dbo].[ConceptoCobro] ([ID])
GO
ALTER TABLE [dbo].[CCReconexion] CHECK CONSTRAINT [FK_CCReconexion_ConceptoCobro]
GO
ALTER TABLE [dbo].[ComprobantePago]  WITH CHECK ADD  CONSTRAINT [FK_ComprobantePago_MedioPago] FOREIGN KEY([IDMedioPago])
REFERENCES [dbo].[MedioPago] ([ID])
GO
ALTER TABLE [dbo].[ComprobantePago] CHECK CONSTRAINT [FK_ComprobantePago_MedioPago]
GO
ALTER TABLE [dbo].[ConceptoCobro]  WITH CHECK ADD  CONSTRAINT [FK_ConceptoCobro_PeriodoMontoCC] FOREIGN KEY([IDPeriodoCC])
REFERENCES [dbo].[PeriodoMontoCC] ([ID])
GO
ALTER TABLE [dbo].[ConceptoCobro] CHECK CONSTRAINT [FK_ConceptoCobro_PeriodoMontoCC]
GO
ALTER TABLE [dbo].[ConceptoCobro]  WITH CHECK ADD  CONSTRAINT [FK_ConceptoCobro_TipoMontoCC] FOREIGN KEY([IDTipoMontoCC])
REFERENCES [dbo].[TipoMontoCC] ([ID])
GO
ALTER TABLE [dbo].[ConceptoCobro] CHECK CONSTRAINT [FK_ConceptoCobro_TipoMontoCC]
GO
ALTER TABLE [dbo].[DetalleCC]  WITH CHECK ADD  CONSTRAINT [FK_DetalleCC_Factura] FOREIGN KEY([IDFactura])
REFERENCES [dbo].[Factura] ([ID])
GO
ALTER TABLE [dbo].[DetalleCC] CHECK CONSTRAINT [FK_DetalleCC_Factura]
GO
ALTER TABLE [dbo].[DetalleCC]  WITH CHECK ADD  CONSTRAINT [FK_DetalleCC_PropiedadXConceptoCobro] FOREIGN KEY([IDPropiedadXConceptoCobro])
REFERENCES [dbo].[PropiedadXConceptoCobro] ([ID])
GO
ALTER TABLE [dbo].[DetalleCC] CHECK CONSTRAINT [FK_DetalleCC_PropiedadXConceptoCobro]
GO
ALTER TABLE [dbo].[DetalleCCArregloPago]  WITH CHECK ADD  CONSTRAINT [FK_DetalleCCArregloPago_DetalleCC] FOREIGN KEY([IDDetalleCC])
REFERENCES [dbo].[DetalleCC] ([ID])
GO
ALTER TABLE [dbo].[DetalleCCArregloPago] CHECK CONSTRAINT [FK_DetalleCCArregloPago_DetalleCC]
GO
ALTER TABLE [dbo].[DetalleCCArregloPago]  WITH CHECK ADD  CONSTRAINT [FK_DetalleCCArregloPago_MovimientoArregloPago] FOREIGN KEY([IDMovimientoArregloPago])
REFERENCES [dbo].[MovimientoArregloPago] ([ID])
GO
ALTER TABLE [dbo].[DetalleCCArregloPago] CHECK CONSTRAINT [FK_DetalleCCArregloPago_MovimientoArregloPago]
GO
ALTER TABLE [dbo].[DetalleCCConsumoAgua]  WITH CHECK ADD  CONSTRAINT [FK_DetalleCCConsumoAgua_DetalleCC] FOREIGN KEY([IDDetalleCC])
REFERENCES [dbo].[DetalleCC] ([ID])
GO
ALTER TABLE [dbo].[DetalleCCConsumoAgua] CHECK CONSTRAINT [FK_DetalleCCConsumoAgua_DetalleCC]
GO
ALTER TABLE [dbo].[DetalleCCConsumoAgua]  WITH CHECK ADD  CONSTRAINT [FK_DetalleCCConsumoAgua_MovimientoConsumoAgua] FOREIGN KEY([IDMovimientoConsumoAgua])
REFERENCES [dbo].[MovimientoConsumoAgua] ([ID])
GO
ALTER TABLE [dbo].[DetalleCCConsumoAgua] CHECK CONSTRAINT [FK_DetalleCCConsumoAgua_MovimientoConsumoAgua]
GO
ALTER TABLE [dbo].[EventLog]  WITH CHECK ADD  CONSTRAINT [FK_EventLog_EntityType] FOREIGN KEY([IDEntityType])
REFERENCES [dbo].[EntityType] ([ID])
GO
ALTER TABLE [dbo].[EventLog] CHECK CONSTRAINT [FK_EventLog_EntityType]
GO
ALTER TABLE [dbo].[EventLog]  WITH CHECK ADD  CONSTRAINT [FK_EventLog_EventType] FOREIGN KEY([IDEventType])
REFERENCES [dbo].[EventType] ([ID])
GO
ALTER TABLE [dbo].[EventLog] CHECK CONSTRAINT [FK_EventLog_EventType]
GO
ALTER TABLE [dbo].[Factura]  WITH CHECK ADD  CONSTRAINT [FK_Factura_ComprobantePago] FOREIGN KEY([IDComprobantePago])
REFERENCES [dbo].[ComprobantePago] ([ID])
GO
ALTER TABLE [dbo].[Factura] CHECK CONSTRAINT [FK_Factura_ComprobantePago]
GO
ALTER TABLE [dbo].[Factura]  WITH CHECK ADD  CONSTRAINT [FK_Factura_Propiedad] FOREIGN KEY([IDPropiedad])
REFERENCES [dbo].[Propiedad] ([ID])
GO
ALTER TABLE [dbo].[Factura] CHECK CONSTRAINT [FK_Factura_Propiedad]
GO
ALTER TABLE [dbo].[MovimientoArregloPago]  WITH CHECK ADD  CONSTRAINT [FK_MovimientoArregloPago_PropiedadXCCArregloPago] FOREIGN KEY([IDPropiedadXCCArregloPago])
REFERENCES [dbo].[PropiedadXCCArregloPago] ([ID])
GO
ALTER TABLE [dbo].[MovimientoArregloPago] CHECK CONSTRAINT [FK_MovimientoArregloPago_PropiedadXCCArregloPago]
GO
ALTER TABLE [dbo].[MovimientoArregloPago]  WITH CHECK ADD  CONSTRAINT [FK_MovimientoArregloPago_TipoMovimientoArregloPago] FOREIGN KEY([IDTipoMovimientoArregloPago])
REFERENCES [dbo].[TipoMovimientoArregloPago] ([ID])
GO
ALTER TABLE [dbo].[MovimientoArregloPago] CHECK CONSTRAINT [FK_MovimientoArregloPago_TipoMovimientoArregloPago]
GO
ALTER TABLE [dbo].[MovimientoConsumoAgua]  WITH CHECK ADD  CONSTRAINT [FK_MovimientoConsumoAgua_PropiedadXCCConsumoAgua] FOREIGN KEY([IDPropiedadXCCConsumoAgua])
REFERENCES [dbo].[PropiedadXCCConsumoAgua] ([IDPropiedadXCC])
GO
ALTER TABLE [dbo].[MovimientoConsumoAgua] CHECK CONSTRAINT [FK_MovimientoConsumoAgua_PropiedadXCCConsumoAgua]
GO
ALTER TABLE [dbo].[MovimientoConsumoAgua]  WITH CHECK ADD  CONSTRAINT [FK_MovimientoConsumoAgua_TipoMovimientoConsumoAgua] FOREIGN KEY([IDTipoMovimientoConsumoAgua])
REFERENCES [dbo].[TipoMovimientoConsumoAgua] ([ID])
GO
ALTER TABLE [dbo].[MovimientoConsumoAgua] CHECK CONSTRAINT [FK_MovimientoConsumoAgua_TipoMovimientoConsumoAgua]
GO
ALTER TABLE [dbo].[OrdenCorte]  WITH CHECK ADD  CONSTRAINT [FK_OrdenCorte_Factura] FOREIGN KEY([IDFactura])
REFERENCES [dbo].[Factura] ([ID])
GO
ALTER TABLE [dbo].[OrdenCorte] CHECK CONSTRAINT [FK_OrdenCorte_Factura]
GO
ALTER TABLE [dbo].[OrdenReconexion]  WITH CHECK ADD  CONSTRAINT [FK_OrdenReconexion_OrdenCorte] FOREIGN KEY([IDOrdenCorte])
REFERENCES [dbo].[OrdenCorte] ([ID])
GO
ALTER TABLE [dbo].[OrdenReconexion] CHECK CONSTRAINT [FK_OrdenReconexion_OrdenCorte]
GO
ALTER TABLE [dbo].[Parametro]  WITH CHECK ADD  CONSTRAINT [FK_Parametro_TipoParametro] FOREIGN KEY([IDTipoParametro])
REFERENCES [dbo].[TipoParametro] ([ID])
GO
ALTER TABLE [dbo].[Parametro] CHECK CONSTRAINT [FK_Parametro_TipoParametro]
GO
ALTER TABLE [dbo].[ParametroInteger]  WITH CHECK ADD  CONSTRAINT [FK_ParametroInteger_Parametro] FOREIGN KEY([IDParametro])
REFERENCES [dbo].[Parametro] ([ID])
GO
ALTER TABLE [dbo].[ParametroInteger] CHECK CONSTRAINT [FK_ParametroInteger_Parametro]
GO
ALTER TABLE [dbo].[Persona]  WITH CHECK ADD  CONSTRAINT [FK_Persona_TipoDocIdentidad] FOREIGN KEY([IDTipoDocIdentidad])
REFERENCES [dbo].[TipoDocIdentidad] ([ID])
GO
ALTER TABLE [dbo].[Persona] CHECK CONSTRAINT [FK_Persona_TipoDocIdentidad]
GO
ALTER TABLE [dbo].[PersonaXPropiedad]  WITH CHECK ADD  CONSTRAINT [FK_PersonaXPropiedad_Persona] FOREIGN KEY([IDPersona])
REFERENCES [dbo].[Persona] ([ID])
GO
ALTER TABLE [dbo].[PersonaXPropiedad] CHECK CONSTRAINT [FK_PersonaXPropiedad_Persona]
GO
ALTER TABLE [dbo].[PersonaXPropiedad]  WITH CHECK ADD  CONSTRAINT [FK_PersonaXPropiedad_Propiedad] FOREIGN KEY([IDPropiedad])
REFERENCES [dbo].[Propiedad] ([ID])
GO
ALTER TABLE [dbo].[PersonaXPropiedad] CHECK CONSTRAINT [FK_PersonaXPropiedad_Propiedad]
GO
ALTER TABLE [dbo].[Propiedad]  WITH CHECK ADD  CONSTRAINT [FK_Propiedad_TipoUsoPropiedad] FOREIGN KEY([IDTipoUsoPropiedad])
REFERENCES [dbo].[TipoUsoPropiedad] ([ID])
GO
ALTER TABLE [dbo].[Propiedad] CHECK CONSTRAINT [FK_Propiedad_TipoUsoPropiedad]
GO
ALTER TABLE [dbo].[Propiedad]  WITH CHECK ADD  CONSTRAINT [FK_Propiedad_TipoZonaPropiedad] FOREIGN KEY([IDTipoZonaPropiedad])
REFERENCES [dbo].[TipoZonaPropiedad] ([ID])
GO
ALTER TABLE [dbo].[Propiedad] CHECK CONSTRAINT [FK_Propiedad_TipoZonaPropiedad]
GO
ALTER TABLE [dbo].[PropiedadXCCArregloPago]  WITH CHECK ADD  CONSTRAINT [FK_PropiedadXCCArregloPago_PropiedadXConceptoCobro] FOREIGN KEY([IDPropiedadXCC])
REFERENCES [dbo].[PropiedadXConceptoCobro] ([ID])
GO
ALTER TABLE [dbo].[PropiedadXCCArregloPago] CHECK CONSTRAINT [FK_PropiedadXCCArregloPago_PropiedadXConceptoCobro]
GO
ALTER TABLE [dbo].[PropiedadXCCArregloPago]  WITH CHECK ADD  CONSTRAINT [FK_PropiedadXCCArregloPago_TasaInteres] FOREIGN KEY([IDTasaInteres])
REFERENCES [dbo].[TasaInteres] ([ID])
GO
ALTER TABLE [dbo].[PropiedadXCCArregloPago] CHECK CONSTRAINT [FK_PropiedadXCCArregloPago_TasaInteres]
GO
ALTER TABLE [dbo].[PropiedadXCCConsumoAgua]  WITH CHECK ADD  CONSTRAINT [FK_PropiedadXCCConsumoAgua_PropiedadXConceptoCobro] FOREIGN KEY([IDPropiedadXCC])
REFERENCES [dbo].[PropiedadXConceptoCobro] ([ID])
GO
ALTER TABLE [dbo].[PropiedadXCCConsumoAgua] CHECK CONSTRAINT [FK_PropiedadXCCConsumoAgua_PropiedadXConceptoCobro]
GO
ALTER TABLE [dbo].[PropiedadXConceptoCobro]  WITH CHECK ADD  CONSTRAINT [FK_PropiedadXConceptoCobro_ConceptoCobro] FOREIGN KEY([IDConceptoCobro])
REFERENCES [dbo].[ConceptoCobro] ([ID])
GO
ALTER TABLE [dbo].[PropiedadXConceptoCobro] CHECK CONSTRAINT [FK_PropiedadXConceptoCobro_ConceptoCobro]
GO
ALTER TABLE [dbo].[PropiedadXConceptoCobro]  WITH CHECK ADD  CONSTRAINT [FK_PropiedadXConceptoCobro_Propiedad] FOREIGN KEY([IDPropiedad])
REFERENCES [dbo].[Propiedad] ([ID])
GO
ALTER TABLE [dbo].[PropiedadXConceptoCobro] CHECK CONSTRAINT [FK_PropiedadXConceptoCobro_Propiedad]
GO
ALTER TABLE [dbo].[Usuario]  WITH CHECK ADD  CONSTRAINT [FK_Usuario_Persona] FOREIGN KEY([IDPersona])
REFERENCES [dbo].[Persona] ([ID])
GO
ALTER TABLE [dbo].[Usuario] CHECK CONSTRAINT [FK_Usuario_Persona]
GO
ALTER TABLE [dbo].[UsuarioXPropiedad]  WITH CHECK ADD  CONSTRAINT [FK_UsuarioXPropiedad_Propiedad] FOREIGN KEY([IDPropiedad])
REFERENCES [dbo].[Propiedad] ([ID])
GO
ALTER TABLE [dbo].[UsuarioXPropiedad] CHECK CONSTRAINT [FK_UsuarioXPropiedad_Propiedad]
GO
ALTER TABLE [dbo].[UsuarioXPropiedad]  WITH CHECK ADD  CONSTRAINT [FK_UsuarioXPropiedad_Usuario] FOREIGN KEY([IDUsuario])
REFERENCES [dbo].[Usuario] ([ID])
GO
ALTER TABLE [dbo].[UsuarioXPropiedad] CHECK CONSTRAINT [FK_UsuarioXPropiedad_Usuario]
GO
