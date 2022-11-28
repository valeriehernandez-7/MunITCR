import {Router} from 'express'
const router = Router()
import {ReadPersona,
        ReadTipoDocID,
        ReadPropiedad,
        ReadTipoUsoPropiedad,
        ReadTipoZonaPropiedad,
        ReadUsuario,
        ReadPersonaXPropiedad,
        ReadPersonaIdentificacion,
        ReadPropiedadLoteAdmin,
        ReadConceptoCobro,
        ReadMedioDePago,
        ReadTipoMovimientoConsumoAgua,
        ReadTipoMontoCC,
        ReadUsuarioXPropiedadIn,
        ReadPropiedadLote,
        ReadPropiedadXUsuario,
        CreatePersona,
        CreateUsuario,
        CreatePropiedad,
        CreatePersonaXPropiedad,
        CreateUsuarioXPropiedad,
        UpdateUsuarioXPropiedad,
        UpdatePersona,
        ReadPropiedadPersonaIn,
        ReadPropiedadInPersona,
        ReadUsuarioInXPropiedad,
        UpdateUsuario,
        UpdatePropiedad,
        UpdatePersonaXPropiedad,
        ReadFacturaPagadaPropiedadIn,
        ReadFacturaPendientePropiedadIn,
        ReadMovimientoConsumoAgua,
        ReadEventLog,
        ReadMedioPago,
        ArregloPagoSolicitud,
        ReadFacturasParaAPIn,
        ReadEventType,
        ReadEntityType,
        ReadEventLogEventInEntityInFechaIn,
        UpdatePersonaXPropiedadDesasociacion,
        DeletePersona,
        DeleteUsuario,
        DeletePropiedad,
        Pago
        } from '../controllers/controller'

//lista de personas     
router.get('/ReadPersona',ReadPersona)

//lista de tipos de documento de ID
router.get('/ReadTipoDocID',ReadTipoDocID)

//lista de propiedades
router.get('/ReadPropiedad',ReadPropiedad)

//listo tipo uso de propiedad
router.get('/ReadTipoUsoPropiedad',ReadTipoUsoPropiedad)

//lista tipo de zona de propiedad
router.get('/ReadTipoZonaPropiedad',ReadTipoZonaPropiedad)

//lista de usuario
router.get('/ReadUsuario',ReadUsuario)

//carga de personasXpropiedades
router.get('/ReadPersonaXPropiedad',ReadPersonaXPropiedad)

//listas de IDs
router.get('/ReadPersonaIdentificacion',ReadPersonaIdentificacion)

//listas Propiedades sin username
router.get('/ReadPropiedadLoteAdmin',ReadPropiedadLoteAdmin)

//listas nombre de conceptos de cobro
router.get('/ReadConceptoCobro',ReadConceptoCobro)

//listas nombre de conceptos de cobro
router.get('/ReadMedioDePago',ReadMedioDePago)

//listas de tipos de movimiento de consumos de agua
router.get('/ReadTipoMovimientoConsumoAgua',ReadTipoMovimientoConsumoAgua)

//listas de tipos de monto CC
router.get('/ReadTipoMontoCC',ReadTipoMontoCC)


//listas propiedades por usuario
router.get('/ReadPropiedadLote',ReadPropiedadLote)

//listas usuarios / propiedades
router.get('/ReadPropiedadXUsuario',ReadPropiedadXUsuario)

//listas de faturas pagadas por propiedad
router.get('/ReadFacturaPagadaPropiedadIn',ReadFacturaPagadaPropiedadIn)

//listas de faturas pendientes por propiedad
router.get('/ReadFacturaPendientePropiedadIn',ReadFacturaPendientePropiedadIn)

//listas de movimientos de consumo de agua
router.get('/ReadMovimientoConsumoAgua',ReadMovimientoConsumoAgua)

//listas de eventos
router.get('/ReadEventLog',ReadEventLog)

//listas de medios de pago
router.get('/ReadMedioPago',ReadMedioPago)

//listas de medios de pago
router.get('/ArregloPagoSolicitud',ArregloPagoSolicitud)

//listas de medios de pago
router.get('/ReadFacturasParaAPIn',ReadFacturasParaAPIn)

//listas de tipos de eventos
router.get('/ReadEventType',ReadEventType)

//listas de  tipos de entidades
router.get('/ReadEntityType',ReadEntityType)

//Agrega una persona a la BD
router.post('/ReadEventLogEventInEntityInFechaIn',ReadEventLogEventInEntityInFechaIn)

//Pago de Facturas
router.post('/Pago',Pago)

//Agrega una persona a la BD
router.post('/CreatePersona',CreatePersona)

//Agrega un usuario a la BD
router.post('/CreateUsuario',CreateUsuario)

//Agrega una propiedad a la BD
router.post('/CreatePropiedad',CreatePropiedad)

//Agrega una asociacion persona/propiedad a la BD
router.post('/CreatePersonaXPropiedad',CreatePersonaXPropiedad)

//Agrega una asociacion usuario/propiedad a la BD
router.post('/CreateUsuarioXPropiedad',CreateUsuarioXPropiedad)

//Agrega una asociacion usuario/propiedad a la BD
router.post('/UpdateUsuarioXPropiedad',UpdateUsuarioXPropiedad)

//Upgradear una persona
router.post('/UpdatePersona',UpdatePersona)

//lista lotes de un user por id
router.post('/ReadPropiedadPersonaIn',ReadPropiedadPersonaIn)

//lista personas por lote
router.post('/ReadPropiedadInPersona',ReadPropiedadInPersona)


//lista de usuarios por propiedad
router.post('/ReadUsuarioInXPropiedad',ReadUsuarioInXPropiedad)

//lista de usuarios por propiedad
router.post('/ReadUsuarioXPropiedadIn',ReadUsuarioXPropiedadIn)

//lista de propietarios por propiedadbn
router.post('/ReadPropiedadXUsuario',ReadPropiedadXUsuario)

//update usuario
router.post('/UpdateUsuario',UpdateUsuario)

//update propiedad
router.post('/UpdatePropiedad',UpdatePropiedad)

//update persona/propiedad
router.post('/UpdatePersonaXPropiedad',UpdatePersonaXPropiedad)

//update persona/propiedad
router.post('/UpdatePersonaXPropiedadDesasociacion',UpdatePersonaXPropiedadDesasociacion)

//Delete persona
router.post('/DeletePersona',DeletePersona)

//Delete usuario
router.post('/DeleteUsuario',DeleteUsuario)

//Delete propiedad
router.post('/DeletePropiedad',DeletePropiedad)


export default router