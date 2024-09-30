import { chromium } from 'playwright';
import * as fs from 'fs';
import * as path from 'path';
import { TIMEOUT } from 'dns';

(async () => {
    let url = "https://bitcoinfaucet.uo1.net";
    let address = "tb1q3nzwatrsnh3znztthm86t9ueshce0y940n08ac";
    let proxies = "https://raw.githubusercontent.com/proxifly/free-proxy-list/main/proxies/protocols/http/data.txt";
    let permitidos = 4;
    let total = 0;

    const browser = await chromium.launch({
        //proxy: {
        //    server: pro,
        //    username: '',
        //    password: ''
        //}
    });

    // Open a new page
    const page = await browser.newPage();
    // Navigate to Google's homepage
    try {
        await page.goto(url);
        await page.waitForTimeout(6000);
        for (let i = 0; i < permitidos; i++) {
            // espero 3 segundos
            // busco el componente de la pagina que se llame send_btn
            const send_btn = await page.$('#send_btn');
            // hay un inputo llamaod to en su id como lo busco
            const to = await page.$('#validationTooltipAddress');
            // to es un input en su value le quiero poner un texto
            await to?.fill(address);
            await send_btn?.click();
            await page.waitForTimeout(10000);
            console.log("enviado :" + i);
            // archivo con la hora de la tomada de la captura en el nombre del archivo pero en formato sin simbolos
            await page.screenshot({ path: 'capturas/termino' + new Date().toISOString().replace(/[^a-zA-Z0-9]/g, '') + '.png' });
        }
    } catch (e) {
        console.log("error");
        console.log(e);
    }
    browser.close();


})();