import { Injectable } from '@nestjs/common';

@Injectable()
export class AddressesService {
  private addresses = [
    {
      id: 'addr-1',
      tag: 'Home',
      flat: 'Flat 402, Tower B',
      street: 'Green Valley Apartments, Vibhuti Khand',
      landmark: 'Near City Mall',
      city: 'Lucknow',
      pincode: '226010',
      isDefault: true,
    },
    {
      id: 'addr-2',
      tag: 'Office',
      flat: 'Unit 304, Cyber Heights',
      street: 'TCG 2/2, Vibhuti Khand',
      landmark: 'Opposite Hyatt Regency',
      city: 'Lucknow',
      pincode: '226010',
      isDefault: false,
    },
  ];

  async findAll() {
    return { success: true, count: this.addresses.length, data: this.addresses };
  }

  async create(dto: any) {
    const newAddr = {
      id: `addr-${Date.now()}`,
      city: 'Lucknow',
      isDefault: false,
      ...dto,
    };
    this.addresses.push(newAddr);
    return { success: true, data: newAddr };
  }

  async googlePlacesAutocomplete(query: string) {
    // Google Maps Places API proxy / fallback for Lucknow service areas
    const mockSuggestions = [
      { description: `${query}, Vibhuti Khand, Gomti Nagar, Lucknow`, placeId: 'pl_101' },
      { description: `${query}, Indira Nagar, Lucknow`, placeId: 'pl_102' },
      { description: `${query}, Hazratganj, Lucknow`, placeId: 'pl_103' },
      { description: `${query}, Aliganj, Lucknow`, placeId: 'pl_104' },
      { description: `${query}, Sushant Golf City, Lucknow`, placeId: 'pl_105' },
    ];
    return { success: true, query, predictions: mockSuggestions };
  }
}
