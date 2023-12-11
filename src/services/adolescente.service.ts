import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';

@Injectable({
  providedIn: 'root'
})
export class AdolescenteService {

  private apiUrl = 'http://localhost:8086/v1/asignations';

  constructor(private http: HttpClient) { }

  getAdolescentList() {
    return this.http.get<any[]>(`${this.apiUrl}/listAdolescents`);
  }
}
