import express from 'express'
import cors from 'cors'
import config from './config'

import itemsRoutes from './routes/items.routes'
import usersRoutes from './routes/users.routes'
import Routes from './routes/routes'



const   app = express();
app.use(cors());

//settings 
app.set('port', config.port);

//middle wares
app.use(express.json());
app.use(express.urlencoded({extended: false}));

app.use(itemsRoutes);
app.use(usersRoutes);
app.use(Routes);
export default app ;