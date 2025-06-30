async function getMessage() {
    const msgDiv = document.getElementById('msg');
    msgDiv.innerText = "Načítám...";
    try {
        const response = await fetch('https://132-164-227-30.sslip.io/api/message');
        if (!response.ok) throw new Error("Chyba serveru");
        const data = await response.json();
        msgDiv.innerText = data.message;
    } catch (error) {
        msgDiv.innerText = "Chyba při komunikaci s backendem!";
    }
}