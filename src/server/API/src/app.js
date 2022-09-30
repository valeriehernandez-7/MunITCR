import express from 'express'
import cors from 'cors'
import config from './config'

import itemsRoutes from './routes/items.routes'
import usersRoutes from './routes/users.routes'



const   app = express();
app.use(cors());

//settings 
app.set('port', config.port);

//middle wares
app.use(express.json());
app.use(express.urlencoded({extended: false}));

app.use(itemsRoutes);
app.use(usersRoutes);
export default app ;