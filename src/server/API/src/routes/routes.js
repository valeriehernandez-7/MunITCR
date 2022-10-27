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
        UpdatePersona,
        ReadPropiedadPersonaIn,
        ReadPropiedadInPersona,
        ReadUsuarioInXPropiedad,
        UpdateUsuario,
        UpdatePropiedad,
        UpdatePersonaXPropiedad
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


export default router