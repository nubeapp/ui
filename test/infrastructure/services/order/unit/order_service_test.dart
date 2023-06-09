import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:ui/domain/entities/event.dart';
import 'package:ui/domain/entities/order.dart';
import 'package:ui/domain/entities/ticket/ticket.dart';
import 'package:ui/domain/entities/ticket/ticket_status.dart';
import 'package:ui/domain/services/order_service_interface.dart';
import 'package:ui/infrastructure/services/order_service.dart';

import '../../../mocks/mock_responses.dart';
import 'order_service_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  late IOrderService orderService;
  const String API_BASE_URL = 'http://0.0.0.0:8000/orders';

  group('OrderService', () {
    group('getOrdersByUserId', () {
      test('return list of orders for the user', () async {
        final mockClient = MockClient();
        orderService = OrderService(client: mockClient);

        when(mockClient.get(Uri.parse(API_BASE_URL))).thenAnswer(
          (_) async => http.Response(json.encode(mockOrderListResponse), 200),
        );

        final orders = await orderService.getOrdersByUserId();

        expect(orders, isA<List<Order>>());
        expect(orders.length, equals(2));
        expect(orders[0].id, equals(1));
        expect(orders[0].event, isA<Event>());
        expect(orders[0].event!.id, equals(1));
        expect(orders[0].event!.title, "Bad Bunny Concert");
        expect(orders[0].event!.date, CustomDateTime(2023, 12, 07));
        expect(orders[0].event!.time, '18:00');
        expect(orders[0].event!.venue, 'Wizink Center');
        expect(orders[0].event!.organization!.id, equals(1));
        expect(orders[0].event!.organization!.name, "UNIVERSAL MUSIC SPAIN");
        expect(orders[0].tickets!, isA<List<Ticket>>());
        expect(orders[0].tickets!.length, equals(2));
        expect(orders[0].tickets![0].id, equals(1));
        expect(orders[0].tickets![1].id, equals(2));
        expect(orders[0].tickets![0].price, equals(10.0));
        expect(orders[0].tickets![1].price, equals(10.0));
        expect(orders[0].tickets![0].reference, "2IR6ZOULKL2HOARDUI19");
        expect(orders[0].tickets![1].reference, "ZT1HT93LEGSVCIEEGAIJ");
        expect(orders[0].tickets![0].status, TicketStatus.SOLD);
        expect(orders[0].tickets![1].status, TicketStatus.SOLD);

        expect(orders[1].id, equals(2));
        expect(orders[1].event, isA<Event>());
        expect(orders[1].event!.id, equals(2));
        expect(orders[1].event!.title, "Rosalia Concert");
        expect(orders[1].event!.date, CustomDateTime(2023, 12, 14));
        expect(orders[1].event!.time, '18:00');
        expect(orders[1].event!.venue, 'Wizink Center');
        expect(orders[1].event!.organization!.id, equals(1));
        expect(orders[1].event!.organization!.name, "UNIVERSAL MUSIC SPAIN");
        expect(orders[1].tickets!, isA<List<Ticket>>());
        expect(orders[1].tickets!.length, equals(2));
        expect(orders[1].tickets![0].id, equals(3));
        expect(orders[1].tickets![1].id, equals(4));
        expect(orders[1].tickets![0].price, equals(20.0));
        expect(orders[1].tickets![1].price, equals(20.0));
        expect(orders[1].tickets![0].reference, "4JUAEAWPB1S6KSSWPN80");
        expect(orders[1].tickets![1].reference, "Y3OPY34TJ9FH78UV4BXG");
        expect(orders[1].tickets![0].status, TicketStatus.SOLD);
        expect(orders[1].tickets![1].status, TicketStatus.SOLD);

        verify(mockClient.get(Uri.parse(API_BASE_URL))).called(1);
      });

      test('throws an exception if the http call completes with an error', () {
        final mockClient = MockClient();
        orderService = OrderService(client: mockClient);

        when(mockClient.get(Uri.parse(API_BASE_URL))).thenAnswer(
          (_) async => http.Response('Not Found', 404),
        );

        expect(orderService.getOrdersByUserId(), throwsException);

        verify(mockClient.get(Uri.parse(API_BASE_URL))).called(1);
      });
    });
  });
}
