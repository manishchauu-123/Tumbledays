import { Controller, Get, Post, Body, Query } from '@nestjs/common';
import { AddressesService } from './addresses.service';

@Controller('api/addresses')
export class AddressesController {
  constructor(private readonly addressesService: AddressesService) {}

  @Get()
  async getAddresses() {
    return this.addressesService.findAll();
  }

  @Post()
  async addAddress(@Body() createAddressDto: any) {
    return this.addressesService.create(createAddressDto);
  }

  @Get('autocomplete')
  async autocompletePlace(@Query('query') query: string) {
    return this.addressesService.googlePlacesAutocomplete(query || 'Gomti Nagar');
  }
}
