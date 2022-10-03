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
        CreatePersona
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

//listas UsuariosXPropiedad por lote
router.get('/ReadUsuarioXPropiedadIn',ReadUsuarioXPropiedadIn)

//listas propiedades por usuario
router.get('/ReadPropiedadLote',ReadPropiedadLote)

//Agrega una persona a la BD
router.post('/CreatePersona',CreatePersona)


export default router