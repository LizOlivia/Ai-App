import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class AiPage extends StatefulWidget {
  const AiPage({super.key});

  @override
  State<AiPage> createState() => _AiPageState();
}

class _AiPageState extends State<AiPage> {
  TextEditingController controller = TextEditingController();
  bool estaCarregando = false;
  String textoGerado = "";


  Future<void> gerarConteudo() async {
    setState(() {
      estaCarregando = true;
    });

    print(controller.text);
    String prompt = controller.text;
    String key = "AIzaSyDuym4QcVQoN0zdgbNQH0sOM-MNu9BB-PI";
    String url =
        "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$key";

    var data = {
      "contents": [
        {
          "parts": [
            {"text": prompt},
          ],
        },
      ],
    };

    try {
      var resposta = await Dio().post(url, data: data);

      if (resposta.statusCode == 200) {
        print(resposta.data);
        setState(() {
          textoGerado = resposta.data["candidates"][0]["content"]["parts"][0]["text"];
        });
      }
      ;
    } catch (erro) {
      print(erro);
    } finally {
      setState(() {
        estaCarregando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double larguraDaTela = MediaQuery.of(context).size.width;
    double alturaDaTela = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage("bg.png"),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(children: [
                    estaCarregando ?
                    CircularProgressIndicator():
                    Text("Texto gerado:"),
                    Text (textoGerado)
                    
                    ]
                    ),
                ),
              ),
              SizedBox(height: 15),
              Container(
                height: alturaDaTela * 0.15,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(color: Colors.white),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: larguraDaTela * 0.7,
                      child: TextFormField(
                        controller: controller,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(),
                          focusedErrorBorder: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: gerarConteudo,
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.deepOrange,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            "Gerar",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
