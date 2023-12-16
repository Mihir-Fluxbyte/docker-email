const express = require("express");
const nodemailer = require("nodemailer");
const path = require("path");

const app = express();
const PORT = 8000;

app.use(express.json());

app.get("/", (req, res) => {
  res.json({
    ok: true,
    routes: {
      ui: "/ui",
      api: "/mailapi",
    },
  });
});

app.use("/ui", express.static(path.join(__dirname, "public")));

app.post("/mailapi", (req, res) => {
  // Extract email parameters from the request body
  const { from, to, subject, text } = req.body;

  // Create a Nodemailer transporter
  const transporter = nodemailer.createTransport({
    host: "localhost",
    port: 1025,
    ignoreTLS: true,
  });

  // Send mail with defined transport object
  transporter.sendMail({ from, to, subject, text }, (err, info) => {
    if (err) {
      console.error("Error occurred. Error:", err);
      res.status(500).json({ error: "Error sending email" });
      return;
    }
    console.log("Email sent. Info:", info);
    res.status(200).json({ message: "Email sent successfully", info });
  });
});

var listener = app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
