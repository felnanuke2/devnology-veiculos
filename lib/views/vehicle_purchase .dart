import 'package:devnology_cars_register/controllers/vehicle_puchase_controller.dart';
import 'package:devnology_cars_register/models/vehicle_detail_model.dart';
import 'package:devnology_cars_register/models/year_model.dart';
import 'package:devnology_cars_register/models/marca_model.dart';
import 'package:devnology_cars_register/models/vehicle_no_details_model.dart';
import 'package:devnology_cars_register/repository/fipe_repository.dart';
import 'package:devnology_cars_register/repository/firebase_repository.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';

class VehiclePurchaseScreen extends StatefulWidget {
  const VehiclePurchaseScreen({Key? key}) : super(key: key);

  @override
  _VehiclePurchaseScreenState createState() => _VehiclePurchaseScreenState();
}

class _VehiclePurchaseScreenState extends State<VehiclePurchaseScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _marcasSearchIniqueKey = UniqueKey();
  late VehiclePurchaseController _controller;
  final placaController = TextEditingController();
  final chassisController = TextEditingController();
  final colorController = TextEditingController();
  final buyDateController = TextEditingController();
  final buyPriceController =
      MoneyMaskedTextController(decimalSeparator: ',', thousandSeparator: '.');
  final formKey = GlobalKey<FormState>();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _controller = VehiclePurchaseController(
        repository: FipeRepository(),
        firebaseRepository: FirebaseRepository(),
        scaffoldKey: _scaffoldKey);

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Aquisição de Veículo'),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Container(
          padding: EdgeInsets.all(12),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                Text(
                  'Selecione o Tipo de Veículo',
                  style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 8,
                ),
                DropdownButtonFormField<VehicleType>(
                    decoration: InputDecoration(
                      labelText: 'Tipo de Veículo',
                      hintText: 'Escolha um Tipo de Veículo',
                    ),
                    value: _controller.type,
                    onChanged: (value) {
                      if (value == null) return;
                      _controller.selectedVehicleTypeInput = value;
                    },
                    items: VehicleType.values
                        .map((e) => DropdownMenuItem(
                              child: Text(
                                e.toString().replaceAll('VehicleType.', ''),
                              ),
                              value: e,
                            ))
                        .toList()),
                SizedBox(
                  height: 15,
                ),
                StreamBuilder<VehicleType?>(
                    stream: _controller.selectedTypeOutput,
                    initialData: _controller.type,
                    builder: (context, snapshotType) {
                      if (snapshotType.data == null) return SizedBox.shrink();
                      return FutureBuilder<List<MarcaModel>>(
                          initialData: [],
                          future: _controller.getMarcas(),
                          builder: (context, snapshotMarcas) {
                            var isLoading =
                                snapshotMarcas.connectionState == ConnectionState.waiting;
                            if (isLoading)
                              return Row(
                                children: [
                                  Expanded(child: DropdownButton(items: [])),
                                  CircularProgressIndicator()
                                ],
                              );
                            List<MarcaModel>? marcasList = snapshotMarcas.data;
                            return Column(
                              children: [
                                Text(
                                  'Selecione a Marca do Veículo',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                DropdownSearch<MarcaModel>(
                                  key: _marcasSearchIniqueKey,
                                  emptyBuilder: (context, searchEntry) => Center(
                                    child: Scaffold(
                                      body: Text(
                                        'Nenhum Resultado por aqui',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  maxHeight: 400,
                                  mode: Mode.BOTTOM_SHEET,
                                  showSearchBox: true,
                                  filterFn: (item, filter) =>
                                      item.fipeName.toLowerCase().contains(filter.toLowerCase()),
                                  compareFn: (item, selectedItem) => item.id == selectedItem?.id,
                                  enabled: !isLoading,
                                  showSelectedItem: true,
                                  items: marcasList!,
                                  itemAsString: (item) => item.fipeName,
                                  label: "Marcas",
                                  hint: "Selecione Uma Marca",
                                  selectedItem: _controller.selectedMarcaModel,
                                  onChanged: (value) {
                                    if (value == null) return;
                                    _controller.selectedMarcaInput = value;
                                  },
                                ),
                              ],
                            );
                          });
                    }),
                SizedBox(
                  height: 15,
                ),
                StreamBuilder<MarcaModel?>(
                  initialData: _controller.selectedMarcaModel,
                  stream: _controller.selectedMarcaModelOutput,
                  builder: (context, snapshotMarcaModel) {
                    if (snapshotMarcaModel.data == null) return SizedBox.shrink();
                    return FutureBuilder<List<VehicleNoDetailModel>>(
                        initialData: [],
                        future: _controller.getVehiclesList(),
                        builder: (context, snapshotVehicles) {
                          var isLoading =
                              snapshotVehicles.connectionState == ConnectionState.waiting;
                          if (isLoading)
                            return Row(
                              children: [
                                Expanded(child: DropdownButton(items: [])),
                                CircularProgressIndicator()
                              ],
                            );
                          List<VehicleNoDetailModel>? vehiclesList = snapshotVehicles.data;
                          return Column(
                            children: [
                              Text(
                                'Selecione o Veículo',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              DropdownSearch<VehicleNoDetailModel>(
                                key: _marcasSearchIniqueKey,
                                emptyBuilder: (context, searchEntry) => Center(
                                  child: Scaffold(
                                    body: Text(
                                      'Nenhum Resultado por aqui',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                ),
                                mode: Mode.BOTTOM_SHEET,
                                showSearchBox: true,
                                filterFn: (item, filter) =>
                                    item.fipeName.toLowerCase().contains(filter.toLowerCase()),
                                compareFn: (item, selectedItem) => item.id == selectedItem?.id,
                                enabled: !isLoading,
                                showSelectedItem: true,
                                items: vehiclesList!,
                                itemAsString: (item) => item.fipeName,
                                label: "Veículo",
                                hint: "Selecione Um Veículo",
                                selectedItem: _controller.selectedVehicleNoDetailModel,
                                onChanged: (value) {
                                  if (value == null) return;
                                  _controller.selectedVehicleNoDetailInput = value;
                                },
                              ),
                            ],
                          );
                        });
                  },
                ),
                SizedBox(
                  height: 15,
                ),
                StreamBuilder<VehicleNoDetailModel?>(
                  initialData: _controller.selectedVehicleNoDetailModel,
                  stream: _controller.selectedVehicleNoDetailOutput,
                  builder: (context, snapshotVehicleNoDetail) {
                    if (snapshotVehicleNoDetail.data == null) return SizedBox.shrink();
                    return FutureBuilder<List<YearModel>>(
                        initialData: [],
                        future: _controller.getAnoModel(),
                        builder: (context, snapshotAnoModelo) {
                          var isLoading =
                              snapshotAnoModelo.connectionState == ConnectionState.waiting;
                          if (isLoading)
                            return Row(
                              children: [
                                Expanded(child: DropdownButton(items: [])),
                                CircularProgressIndicator()
                              ],
                            );
                          List<YearModel>? vehiclesList = snapshotAnoModelo.data;
                          return Column(
                            children: [
                              Text(
                                'Selecione o Ano do  Veículo',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              DropdownSearch<YearModel>(
                                key: _marcasSearchIniqueKey,
                                emptyBuilder: (context, searchEntry) => Center(
                                  child: Scaffold(
                                    body: Text(
                                      'Nenhum Resultado por aqui',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                ),
                                mode: Mode.BOTTOM_SHEET,
                                showSearchBox: true,
                                filterFn: (item, filter) =>
                                    item.name.toLowerCase().contains(filter.toLowerCase()),
                                compareFn: (item, selectedItem) => item.id == selectedItem?.id,
                                enabled: !isLoading,
                                showSelectedItem: true,
                                items: vehiclesList!,
                                itemAsString: (item) => item.key,
                                label: "Ano",
                                hint: "Selecione o Ano do Veículo",
                                selectedItem: _controller.anoModel,
                                onChanged: (value) {
                                  if (value == null) return;
                                  _controller.selectedAnoModeloInput = value;
                                },
                              ),
                            ],
                          );
                        });
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                StreamBuilder<YearModel?>(
                  initialData: _controller.anoModel,
                  stream: _controller.selectedAnoModeloOutput,
                  builder: (context, snapshotYearModel) {
                    if (snapshotYearModel.data == null) return SizedBox.shrink();
                    return FutureBuilder<VehicleWithDetaillModel?>(
                        initialData: _controller.vehicleWithDetail,
                        future: _controller.getVehicleWithDetail(),
                        builder: (context, snapshotvehicleWithDetail) {
                          var isLoading =
                              snapshotvehicleWithDetail.connectionState == ConnectionState.waiting;
                          if (isLoading) return Center(child: CircularProgressIndicator());
                          if (snapshotvehicleWithDetail.data == null) return SizedBox.shrink();
                          var vehicle = snapshotvehicleWithDetail.data!;
                          return Container(
                            margin: EdgeInsets.symmetric(vertical: 15),
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.2),
                                border: Border.all(),
                                borderRadius: BorderRadius.circular(16)),
                            child: Column(
                              children: [
                                Text(
                                  'Fipe Para Referência',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Veículo: ',
                                      style: TextStyle(fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      vehicle.name,
                                      maxLines: 1,
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Marca: ',
                                      style: TextStyle(fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      vehicle.marca,
                                      maxLines: 1,
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Ano/Modelo: ',
                                      style: TextStyle(fontWeight: FontWeight.w600),
                                    ),
                                    Text(vehicle.anoModelo),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Preços Fipe: ',
                                      style: TextStyle(fontWeight: FontWeight.w600),
                                    ),
                                    Text(vehicle.preco),
                                  ],
                                ),
                              ],
                            ),
                          );
                        });
                  },
                ),
                TextFormField(
                  maxLength: 7,
                  controller: placaController,
                  validator: (value) {
                    if (value!.length < 7) return 'Placa Inválida';
                    return null;
                  },
                  textCapitalization: TextCapitalization.characters,
                  decoration: InputDecoration(labelText: 'Placa'),
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: chassisController,
                  validator: (value) {
                    if (value!.length < 17) return 'Chassis Inválido';
                    return null;
                  },
                  maxLength: 17,
                  textCapitalization: TextCapitalization.characters,
                  decoration: InputDecoration(labelText: 'Número do Chassis'),
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: buyPriceController,
                  validator: (value) {
                    value = buyPriceController.text;
                    if (value.isEmpty) return 'Isira um Preço para essa Compra';
                    if (value == '0,00') return 'Preço Inválido';
                    return null;
                  },
                  textCapitalization: TextCapitalization.characters,
                  decoration: InputDecoration(labelText: 'Valor da Compra'),
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: buyDateController,
                  validator: (value) {
                    if (value!.isEmpty) return 'Data é um Campo Obrigatório';
                    return null;
                  },
                  onTap: () async {
                    _controller
                        .pickBuyDate(context)
                        .then((value) => value != null ? buyDateController.text = value : null);
                  },
                  readOnly: true,
                  textCapitalization: TextCapitalization.characters,
                  decoration: InputDecoration(labelText: 'Data da Compra'),
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) return 'Você precisa escolher uma cor';
                  },
                  controller: colorController,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(labelText: 'Cor do Veículo'),
                ),
                SizedBox(
                  height: 20,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: StreamBuilder<bool>(
                      stream: _controller.loadingOutput,
                      initialData: false,
                      builder: (context, snapshotloading) {
                        bool isLoading = snapshotloading.data == true;

                        return AnimatedContainer(
                            height: 38,
                            width: isLoading ? 38 : 160,
                            duration: Duration(milliseconds: 180),
                            child: isLoading
                                ? CircularProgressIndicator()
                                : ElevatedButton(
                                    onPressed: () {
                                      if (!formKey.currentState!.validate()) return;
                                      _controller.createnewVehicle(
                                          placaController.text,
                                          chassisController.text,
                                          buyPriceController.text,
                                          colorController.text);
                                    },
                                    child: Text('Cadastrar Veículo')));
                      }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
