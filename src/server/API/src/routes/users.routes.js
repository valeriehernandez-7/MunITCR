import {Router} from 'express'
import {login} from '../controllers/users.controller'

const router = Router()

router.get('/login',login)

export default router