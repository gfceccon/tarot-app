# Tarot App
Aplicativo para referência de cartas de tarot, usando imagens do deck de tarot de Rider-Waite. O app inclui: login, signup, visualização por arcana e leitura de 3 cartas.

## ⚠ Disclaimer ⚠
Aplicativo inclui imagens que contém conteúdo explícito.

# Como rodar
Aplicativo feito em flutter, é necessário instalar o pacote flutter junto com as suas dependências. O aplicativo faz uso do Firebase, então é necessária uma conta no mesmo.

## Flutter firebase
Instalação do bash e login. Após o login, seguir as instruções de configuração do projeto na pasta do aplicativo `tarot`
```
curl -sL https://firebase.tools | bash
firebase login
cd tarot
flutterfire configure
```

## Configuração do banco de dados
O app faz uso do banco de dados Firestore, é necessário configurar o Firestore dentro do Firebase e incluir nele as cartas. Para isso, basta rodar o aplicativo Node.js dentro de `tarot-upload`, após a inclusão da chave Web do Firebase.

### Firebase Web
Dentro de `tarot-upload/index.js`, incluir a chave do aplicativo do Firebase:
```
const firebaseConfig = {
  apiKey: "",
  authDomain: "",
  projectId: "",
  storageBucket: "",
  messagingSenderId: "",
  appId: ""
};
```
Após feito isso, apenas rodar o comando de instalação e execução Node.js:
```
cd tarot-upload
npm install
npm start
```

# Integrantes
Gustavo Ferreira Ceccon

Guilherme Andrades Guimarães