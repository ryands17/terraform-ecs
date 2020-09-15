import * as express from 'express'
import * as cors from 'cors'
import * as helmet from 'helmet'
import { users } from './users'

const PORT = process.env.PORT || 4000

const app = express()

app.use(cors())
app.use(helmet())

app.get('/health-check', (_, res) => {
  res.send('API is functional!')
})

app.get('/', (_, res: express.Response) => {
  res.json({
    data: {
      users,
    },
  })
})

app.listen(PORT, () => console.log(`App running on port ${PORT}`))
