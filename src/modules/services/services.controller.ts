import { Controller, Get, Param } from '@nestjs/common';
import { ServicesService } from './services.service';

@Controller('api/services')
export class ServicesController {
  constructor(private readonly servicesService: ServicesService) {}

  @Get()
  async getServices() {
    return this.servicesService.findAll();
  }

  @Get(':id/catalog')
  async getServiceCatalog(@Param('id') serviceId: string) {
    return this.servicesService.findCatalog(serviceId);
  }
}
